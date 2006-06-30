From: Akos Maroy <darkeye@tyrell.hu>
Subject: Re: raid issues after power failure
Date: Fri, 30 Jun 2006 08:29:34 -0400 (EDT)
Message-ID: <Pine.LNX.4.63.0606300827570.30060@turos>
References: <49954.82.141.169.118.1151658773.squirrel@mail.tyrell.hu>
 <fd8d0180606300221x2280e220qd6f5fcd1096ff37b@mail.gmail.com>
 <49971.82.141.169.118.1151659502.squirrel@mail.tyrell.hu>
 <fd8d0180606300250q6fbab5d3wdf343b530f3119a9@mail.gmail.com>
 <fd8d0180606300251p9129a8cr41c62bf87191cf39@mail.gmail.com>
 <fd8d0180606300256j324dbcbfnb9aa21432b22eba1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fd8d0180606300256j324dbcbfnb9aa21432b22eba1@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francois Barre <francois.barre@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 30 Jun 2006, Francois Barre wrote:
> I'm wondering :
> sd[acd] has an Update Time : Thu Jun 29 09:10:39 2006
> sdb has an Update Time : Mon Jun 26 20:27:44 2006
>
> When did your power failure happen ?

yesterday (29th). so it seems that /dev/sdb1 failed out on the 26th, and I 
just didn't take notice? :(

> When did you run your mdadm -A /dev/md0 ?

after the power failure was over, and I had a chance to restart the 
machine. late on the 29th...

so, the situation seems that my array was degraded already when the power 
failure happened, and then it got into the dirty state. what can one do 
about such a situation?


Akos

