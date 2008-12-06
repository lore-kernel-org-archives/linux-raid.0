From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: weird issues with raid1
Date: Sat, 6 Dec 2008 07:16:36 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0812060715380.8516@p34.internal.lan>
References: <cccedfc60812051810q3c44ae28x514072cb870ac390@mail.gmail.com> <cccedfc60812051846l3352a5f3medc9e921e29c7434@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60812051846l3352a5f3medc9e921e29c7434@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On Fri, 5 Dec 2008, Jon Nelson wrote:

> More info:
>
> according to /dev/mdstat (and /var/log/messages) the rebuild is complete:
>
> md10 : active raid1 sda[0] nbd0[1]
>      78123968 blocks [2/2] [UU]
>      bitmap: 0/150 pages [0KB], 256KB chunk

I have not tried using network block devices or the write-behind option;
however, Neil et. all will want to know:

- kernel version used
- mdadm version

In order to help better track the issues.

Justin.

