From: =?ISO-8859-1?Q?=C1kos_Mar=F3y?= <darkeye@tyrell.hu>
Subject: Re: raid issues after power failure
Date: Mon, 03 Jul 2006 13:30:55 +0200
Message-ID: <44A8FFEF.30500@tyrell.hu>
References: <49954.82.141.169.118.1151658773.squirrel@mail.tyrell.hu>	 <fd8d0180606300251p9129a8cr41c62bf87191cf39@mail.gmail.com>	 <fd8d0180606300256j324dbcbfnb9aa21432b22eba1@mail.gmail.com>	 <Pine.LNX.4.63.0606300827570.30060@turos>	 <fd8d0180606300540r3c957a7duf0c831917f55be7f@mail.gmail.com>	 <Pine.LNX.4.63.0606300842430.30060@turos>	 <17573.44678.188170.409349@cse.unsw.edu.au>	 <44A69496.9030109@tyrell.hu>	 <fd8d0180607020114m5e02e1ek553e5da2941eb6dd@mail.gmail.com>	 <44A8DB48.8080905@tyrell.hu> <fd8d0180607030216t5f26db56mab091f1418a8e322@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fd8d0180607030216t5f26db56mab091f1418a8e322@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francois Barre <francois.barre@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Francois Barre wrote:
> AFAIK, mdadm -A <raid device> will use /etc/mdadm.conf to know what
> underlying partitions you mean with your /dev/md0.
> 
> So, try
> 
> # mdadm --stop /dev/md0
> # mdadm -A /dev/md0 /dev/sd[abcd]1
> 
> And then have a look on your /etc/mdadm.conf, especially the line
> starting by
> ARRAY /dev/md0 ...

yes, I already found the problem in /etc/mdadm.conf , and it was totally
my mistake..

sorry to bother you with such lame problems.


Akos
