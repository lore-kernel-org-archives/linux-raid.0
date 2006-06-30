From: "Francois Barre" <francois.barre@gmail.com>
Subject: Re: raid issues after power failure
Date: Fri, 30 Jun 2006 14:57:55 +0200
Message-ID: <fd8d0180606300557o76c2145eqbbac07a1df3ba3cc@mail.gmail.com>
References: <49954.82.141.169.118.1151658773.squirrel@mail.tyrell.hu>
	 <fd8d0180606300221x2280e220qd6f5fcd1096ff37b@mail.gmail.com>
	 <49971.82.141.169.118.1151659502.squirrel@mail.tyrell.hu>
	 <fd8d0180606300250q6fbab5d3wdf343b530f3119a9@mail.gmail.com>
	 <fd8d0180606300251p9129a8cr41c62bf87191cf39@mail.gmail.com>
	 <fd8d0180606300256j324dbcbfnb9aa21432b22eba1@mail.gmail.com>
	 <Pine.LNX.4.63.0606300827570.30060@turos>
	 <fd8d0180606300540r3c957a7duf0c831917f55be7f@mail.gmail.com>
	 <Pine.LNX.4.63.0606300842430.30060@turos>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.63.0606300842430.30060@turos>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Akos Maroy <darkeye@tyrell.hu>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2006/6/30, Akos Maroy <darkeye@tyrell.hu>:
> On Fri, 30 Jun 2006, Francois Barre wrote:
> > Did you try upgrading mdadm yet ?
>
> yes, I have version 2.5 now, and it produces the same results.
>
>
> Akos
>
>

And I suppose there is no change in the various outputs mdadm is able
to produce (i.e. -D or -E).
Can you still access your md drive while it's resyncing ? There's
nothing showing up in the dmesg ? Did you try to play with the sysfs
access to md (forcing resync, ...).

I have not seen any deadlock-related patch in md from 2.6.16 to
current 2.6.17.2, but, if you have nothing to do, you could give it a
try I guess..
