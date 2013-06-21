From: Nic Wolfe <nic@wolfeden.ca>
Subject: Re: RAID6 growing interrupted, array won't assemble or resume growing
Date: Thu, 20 Jun 2013 22:17:20 -0600
Message-ID: <CAGjXdAid7NRn2hQyhdkf8quEEmiqg9P0Ro5hocZdFbt1n8H8tQ@mail.gmail.com>
References: <CAGjXdAhMHEFFc1C0XUSY_K1ZxwaRG-x=NEw9H2Aiv+YtNat-tw@mail.gmail.com>
	<51B0C769.1070009@turmel.org>
	<CAGjXdAj+xsW=Ut9EUz65Ha_ZaGwgzJwRG6vh+9S60jpCK1qNpA@mail.gmail.com>
	<51B1D58A.3010309@turmel.org>
	<CAGjXdAjgRTho6r8EdM04wBNR90uvbt72cWmkNy9_AuEt-qi1hw@mail.gmail.com>
	<51C1FA44.1070306@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51C1FA44.1070306@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 19, 2013 at 12:36 PM, Phil Turmel <philip@turmel.org> wrote:
> On 06/19/2013 02:21 AM, Nic Wolfe wrote:

> As noted above, you will not be able to use /dev/sdc with the raid card.
>  You could try leaving it out and taking a backup with the degraded
> array.  That is what I would recommend first.

midgetspy@MidgetNAS:~$ sudo mdadm --assemble /dev/md1 /dev/sdd
/dev/sdb /dev/sde /dev/sdf /dev/sdg
mdadm: Failed to restore critical section for reshape, sorry.

Some googling indicated that my mdadm version (2.6.3) has a known
issue with reshapes so I got the 3.2.6 source and built it and tried
again:

midgetspy@MidgetNAS:~/mdadm-3.2.6$ sudo ./mdadm --assemble /dev/md1
/dev/sdd /dev/sdb /dev/sde /dev/sdf /dev/sdg
mdadm: /dev/md1 assembled from 1 drive - not enough to start the array.
midgetspy@MidgetNAS:~/mdadm-3.2.6$ cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md1 : inactive sdg[5](S) sdf[4](S) sde[3](S) sdb[2](S) sdd[0](S)
      9767157440 blocks super 0.91

unused devices: <none>

mdadm --examine: http://pastebin.com/FRQDXDLB

I'm not sure where to go from here.

Thanks,

Nic
