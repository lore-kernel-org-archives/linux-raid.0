From: Tomas Vanderka <vanto@ynet.sk>
Subject: Re: mdrecoveryd oops
Date: Thu, 30 May 2002 18:00:53 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0205301743480.32022-100000@marvin.ynet.sk>
References: <Pine.LNX.4.30.0205301148420.13515-101000@duplo.agenda.si>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.30.0205301148420.13515-101000@duplo.agenda.si>
To: Danilo Godec <danci@agenda.si>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 30 May 2002, Danilo Godec wrote:

> It *should* work. Are you using this on a SMP machine? There are some race
> situations causing crashes, but it should work with an UP machine.
> 

It's an UP machine. I was asking this question because we had raid0 and it 
was OK. Now with raid5, machine dies after about 5-6 days. Usually kswapd 
oopses in some raid5 routine while manipulating with stripe list.


> Here is a patch produced by gody@agenda.si that should help in SMP
> machine. It not pretty and it's not '100% right', but it seems to work.
> 
>    D.


