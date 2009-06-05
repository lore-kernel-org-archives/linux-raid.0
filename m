From: Neil Brown <neilb@suse.de>
Subject: Re: md raid5 keeps going degraded.
Date: Fri, 5 Jun 2009 11:16:23 +1000
Message-ID: <18984.29159.555653.178944@notabene.brown>
References: <007001c9e577$9cdedd10$d69c9730$@co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jack Etherington on Friday June 5
Sender: linux-raid-owner@vger.kernel.org
To: Jack Etherington <jack@the-etheringtons.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday June 5, jack@the-etheringtons.co.uk wrote:
> Hello,
> I am not sure whether troubleshooting messages are allowed on the mda=
dm
> mailing list (or it is for development and bugs only) so please point=
 me in
> the right direction if this is not the right place.

Anything about raid and linux is welcome here.

>=20
> Before posting here I have tried using the following resources for
> information:
> >Google
> >Distribution IRC channel (Ubuntu)
> >Linuxquestions.org
>=20
> My knowledge of Linux is beginner/moderate.
>=20
> My setup is:
> 9x1tb Hard Drives (2xhitachi and 7x Samsung HD103UJ)
> Supermicro AOC-SAT2-MV8 8 Port SATA Card
> 1xMotherboard SATA port
> Single RAID5 array created with mdadm, printout of /proc/mdstat:
>=20
> root@server3:~# cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] =
[raid4]
> [raid10]
> md0 : active raid5 sdj1[7] sdc1[0] sda1[8] sdg1[6] sdi1[9](F) sdd1[4]
> sde1[3] sdh1[2] sdf1[10](F)
> =1B,A     =1B(B 7814079488 blocks level 5, 64k chunk, algorithm 2 [9/=
7] [U_UUU_UUU]
>=20
>=20
> A printout of /var/messages is available here: http://pastebin.com/m6=
499846
> as not to make this post any longer...
> (The array has been down for about a month now. It is my home storage
> server, non-critical, but I do not have a backup)
>=20
> Also a printout of =91mdadm --detail /dev/md0=92 is available here:
> http://pastebin.com/f44b6e069
>=20
> I have used =91mdadm -v -A -f /dev/md0=92 to get the array online aga=
in, and can
> read data (intact without errors) from the array, but it soon becomes
> degraded again.

This definitely suggests some sort of hardware problem.
The message "SATA link down" could suggest a cabling problem.
The "START_STOP FAILED" might suggest that drive hard problems
spinning up, make the power supply in marginal...

Is it always the same drives that fail, or does it vary.
If it is the same, try checking the cables and maybe swapping cables
to see if the problem moves with the cable.
If it varies, then check the max power draw of the drives, and the max
current that can be supplied by the power supply.  Possibly you need a
new one.

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
