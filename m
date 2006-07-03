From: "Francois Barre" <francois.barre@gmail.com>
Subject: Re: raid issues after power failure
Date: Mon, 3 Jul 2006 11:16:58 +0200
Message-ID: <fd8d0180607030216t5f26db56mab091f1418a8e322@mail.gmail.com>
References: <49954.82.141.169.118.1151658773.squirrel@mail.tyrell.hu>
	 <fd8d0180606300251p9129a8cr41c62bf87191cf39@mail.gmail.com>
	 <fd8d0180606300256j324dbcbfnb9aa21432b22eba1@mail.gmail.com>
	 <Pine.LNX.4.63.0606300827570.30060@turos>
	 <fd8d0180606300540r3c957a7duf0c831917f55be7f@mail.gmail.com>
	 <Pine.LNX.4.63.0606300842430.30060@turos>
	 <17573.44678.188170.409349@cse.unsw.edu.au>
	 <44A69496.9030109@tyrell.hu>
	 <fd8d0180607020114m5e02e1ek553e5da2941eb6dd@mail.gmail.com>
	 <44A8DB48.8080905@tyrell.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44A8DB48.8080905@tyrell.hu>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?=C1kos_Mar=F3y?= <darkeye@tyrell.hu>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> # mdadm --stop /dev/md0
> # mdadm -A /dev/md0
>
> will result in the array started with 3 drives out of 4 again. what am I
> doing wrong?
>
>
> Akos

AFAIK, mdadm -A <raid device> will use /etc/mdadm.conf to know what
underlying partitions you mean with your /dev/md0.

So, try

# mdadm --stop /dev/md0
# mdadm -A /dev/md0 /dev/sd[abcd]1

And then have a look on your /etc/mdadm.conf, especially the line starting by
ARRAY /dev/md0 ...

Regards,
