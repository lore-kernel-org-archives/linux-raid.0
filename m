From: Thomas Steudten <alpha@steudten.com>
Subject: Re: md raid oops on 2.4.25/alpha
Date: Mon, 29 Mar 2004 12:41:06 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4067FD42.9030206@steudten.com>
References: <20031027141358.GA26271@gamma.logic.tuwien.ac.at> <20040327164153.GA7324@gamma.logic.tuwien.ac.at> <20040328160246.GA19965@gamma.logic.tuwien.ac.at> <40670BAE.4060901@steudten.com> <20040328223013.A15859@jurassic.park.msu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040328223013.A15859@jurassic.park.msu.ru>
To: Norbert Preining <preining@logic.at>, linux-kernel@vger.kernel.org
Cc: linux-raid@vger.kernel.org, mingo@redhat.com, neilb@cse.unsw.edu.au
List-Id: linux-raid.ids

I know from my own system, that the oops in the raid1 sources, are
not the only point, where gcc generates wrong assembler code.
So it't better not to workaround just this single point, but
use the fixed gcc instead.

Ivan Kokshaysky wrote:

> Also, here is a hack (originally from Jay Estabrook) which
> should work around a bug in older compilers.

