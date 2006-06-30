From: "Francois Barre" <francois.barre@gmail.com>
Subject: Re: raid issues after power failure
Date: Fri, 30 Jun 2006 11:56:38 +0200
Message-ID: <fd8d0180606300256j324dbcbfnb9aa21432b22eba1@mail.gmail.com>
References: <49954.82.141.169.118.1151658773.squirrel@mail.tyrell.hu>
	 <fd8d0180606300221x2280e220qd6f5fcd1096ff37b@mail.gmail.com>
	 <49971.82.141.169.118.1151659502.squirrel@mail.tyrell.hu>
	 <fd8d0180606300250q6fbab5d3wdf343b530f3119a9@mail.gmail.com>
	 <fd8d0180606300251p9129a8cr41c62bf87191cf39@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fd8d0180606300251p9129a8cr41c62bf87191cf39@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?=C1kos_Mar=F3y?= <darkeye@tyrell.hu>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

(answering to myself is one of my favourite hobbies)
>
> Yep, this looks like it.
> The events difference is quite big : 0.2701790 vs. 0.2607131... Could
> it be that the sdb1 was marked faulty a couple of seconds before the
> power failure ?
>

I'm wondering :
sd[acd] has an Update Time : Thu Jun 29 09:10:39 2006
sdb has an Update Time : Mon Jun 26 20:27:44 2006

When did your power failure happen ?
When did you run your mdadm -A /dev/md0 ?
