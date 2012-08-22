From: Jan Ceuleers <jan.ceuleers@computer.org>
Subject: Re: Spares not added upon reboot after distro upgrade
Date: Wed, 22 Aug 2012 13:26:03 +0200
Message-ID: <5034C1CB.80808@computer.org>
References: <50309900.9040108@computer.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50309900.9040108@computer.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/19/2012 09:42 AM, Jan Ceuleers wrote:
...

> For the first time ever I tried mdadm's incremental mode. So before
> issuing the above two commands I tried the following;
> 
> root@zotac:~# mdadm -I /dev/sde2
> mdadm: failed to add /dev/sde2 to /dev/md0: Invalid argument.

I have now straced this, and here are the offending lines:

ioctl(4, 0x40140921, 0x7fff4bda3858)    = -1 EINVAL (Invalid argument)
write(2, "mdadm: failed to add /dev/sde2 t"..., 62mdadm: failed to add
/dev/sde2 to /dev/md0: Invalid argument.

fd 4 is /dev/md0

How does one decode the ioctl call?

Thanks, Jan
