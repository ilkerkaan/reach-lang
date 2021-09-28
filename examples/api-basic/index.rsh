'reach 0.1';
'use strict';

const State = Tuple(Bool, UInt, UInt, UInt);

export const main = Reach.App(() => {
  const A = Participant('Admin', {
    ...hasConsoleLogger,
    tok: Token,
  });
  const V = View('Reader', {
    read: Fun([], State),
  });
  const U = API('Writer', {
    touch: Fun([UInt], State),
    writeN: Fun([UInt], State),
    writeT: Fun([UInt], State),
    writeB: Fun([UInt], State),
    end: Fun([], State),
  });
  deploy();

  A.only(() => {
    const [ tok, amt ] = declassify([ A.tok, A.amt ]);
  });
  A.publish(tok).pay([amt, tok]);

  const [ done, x, an, at ] =
    parallelReduce([ false, 0, 0, amt ])
    .invariant(balance() == an && balance(tok) == at)
    .define(() => {
      V.read.set([done, x, an, at ]);
    })
    .while( ! done )
    .paySpec([tok])
    .api(U.touch, ((_) => [ 0, [ 0, tok ] ]), ((i, k) => {
        const stp = [ done, x + i, an, at ];
        k(stp);
        return stp;
    }))
    .api(U.writeN, ((_) => [ amt, [ 0, tok ] ]), ((i, k) => {
        const stp = [ done, x + i, an + amt, at ];
        k(stp);
        return stp;
    }))
    .api(U.writeT, ((_) => [ 0, [ amt, tok ] ]), ((i, k) => {
        const stp = [ done, x + i, an, at + amt ];
        k(stp);
        return stp;
    }))
    .api(U.writeB, ((_) => [ amt, [ amt, tok ] ]), ((i, k) => {
        const stp = [ done, x + i, an + amt, at + amt ];
        k(stp);
        return stp;
    }))
    .api(U.end, ((_) => [ 0, [ 0, tok ] ]), ((i, k) => {
        const stp = [ true, x, an, at ];
        k(stp);
        return stp;
    }));

  transfer(an).to(Admin);
  transfer(at, tok).to(Admin);
  commit();

  exit();
});
