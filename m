From: Norbert Preining <preining@logic.at>
Subject: Re: md raid oops on 2.4.25/alpha
Date: Sun, 28 Mar 2004 22:32:10 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040328203210.GD3633@gamma.logic.tuwien.ac.at>
References: <20031027141358.GA26271@gamma.logic.tuwien.ac.at> <20040327164153.GA7324@gamma.logic.tuwien.ac.at> <20040328160246.GA19965@gamma.logic.tuwien.ac.at> <40670BAE.4060901@steudten.com> <20040328223013.A15859@jurassic.park.msu.ru> <20031027141358.GA26271@gamma.logic.tuwien.ac.at> <20040327164153.GA7324@gamma.logic.tuwien.ac.at> <20040328160246.GA19965@gamma.logic.tuwien.ac.at> <40670BAE.4060901@steudten.com> <200403290245.51813.ross@datscreative.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040328115951.A30976@mail.harddata.com> <20040328223013.A15859@jurassic.park.msu.ru> <40670BAE.4060901@steudten.com> <200403290245.51813.ross@datscreative.com.au>
To: Ross Dickson <ross@datscreative.com.au>, Thomas Steudten <alpha@steudten.com>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Michal Jaegermann <michal@harddata.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, mingo@redhat.com, neilb@cse.unsw.edu.au
List-Id: linux-raid.ids

Thanks all for the quick answer ...

On Son, 28 M=E4r 2004, Ivan Kokshaysky wrote:
> Also, here is a hack (originally from Jay Estabrook) which
> should work around a bug in older compilers.

I used this diff and it is working now, at least I hope, tests are
coming.

Again, thanks again for the fast answer!

Best wishes

Norbert

-----------------------------------------------------------------------=
--------
Norbert Preining <preining AT logic DOT at>         Technische Universi=
t=E4t Wien
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 0=
9C5 B094
-----------------------------------------------------------------------=
--------
HODNET (n.)
The wooden safety platform supported by scaffolding round a building
under construction from which the builders (at almost no personal
risk) can drop pieces of cement on passers-by.
			--- Douglas Adams, The Meaning of Liff
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
