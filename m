From: Neil Brown <neilb@suse.de>
Subject: Re: raid issues after power failure
Date: Sat, 1 Jul 2006 09:06:46 +1000
Message-ID: <17573.44678.188170.409349@cse.unsw.edu.au>
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
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Akos Maroy on Friday June 30
Sender: linux-raid-owner@vger.kernel.org
To: Akos Maroy <darkeye@tyrell.hu>
Cc: Francois Barre <francois.barre@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Friday June 30, darkeye@tyrell.hu wrote:
> On Fri, 30 Jun 2006, Francois Barre wrote:
> > Did you try upgrading mdadm yet ?
> 
> yes, I have version 2.5 now, and it produces the same results.
> 

Try adding '--force' to the -A line.
That tells mdadm to try really hard to assemble the array.

You should be aware that when a degraded array has an unclean
shutdown it is possible that data corruption could result, possibly in
files that have not be changed for a long time.  It is also quite
possible that there is no data corruption, or it is only on part of
the array that are not actually in use.

I recommend at least a full 'fsck' in this situation.

NeilBrown
