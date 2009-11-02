From: Jesse Wheeler <jwwstpete@gmail.com>
Subject: Re: system update killed /boot RAID-1 array auto-assembly/mount. why?
Date: Mon, 2 Nov 2009 16:25:03 -0500
Message-ID: <f1ef83020911021325uf1be098ia4567931771f88ae@mail.gmail.com>
References: <babafd2f0911021224w6adf8453we7ba4f166102044f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <babafd2f0911021224w6adf8453we7ba4f166102044f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ben:

I've observed some similar behavior on RAID-5 w/ SuSE Enterprise
Server 10.2 SP2 with our eDirectory boxes.  While this is different
from my current issue that I posted today, I will say that I have had
-- on average -- better luck with with RHEL based distributions than
SuSE variants.

I've noticed that Novell tends to make just ever so slight changes to
the back-ports that they place into their 'Enterprise' kernel.  That
being said, Novell is also the only current Enterprise grade Linux
vendor to actually place 'sane' options into the default
partitioning/mounting scheme for Ext3 -- i.e.,
'barrier=3D1,data=3Djournal,noatime'.  However, this doesn't apply to
software raid/linux MD schemes since (AFAIK), only linear/single drive
Ext3 partitions can mount w/ 'barrier=3D1'.

This has been my hell for the last month.. 'Enterprise Linux'
distributions, filesystems, software vs. hardware RAID, and data loss.
 I've lost many-an-hour sleep ;o)!

--
Jesse W. Wheeler
Member-Owner
Devotio Consulting, L.L.C.
--

On Mon, Nov 2, 2009 at 3:24 PM, Ben DJ
<bendj095124367913213465@gmail.com> wrote:
> Hi,
>
> I've installed OpenSuse 11.2 RC2 to
>
> =A0/boot on =A04-disk RAID-1, super=3D1.0
> =A0/root =A0& (etc) on 4-disk RAID-10,f2 chunk=3D256, super=3D1.1
>
> It's been running fine.
>
> After a recent system upgrade via 'zypper dup', which completed
> without any apparent error, reboot failed. =A0/boot @ /dev/md0 was no=
t
> mounting, and the RAID-1 wasn't even assembling.
>
> A full day of reading, and trying various repair-the-array solutions
> couldn't get me back.
>
> Although I was able to manually mount the array, and it fsck'ed ok, I
> couldn't get the array to auto-assemble.
>
> Finally, I deleted the array, repartitioned the drive, reinstalled
> kernel, grub and mdadm, and I'm back in business. =A0At the moment, t=
he
> RAID-10 array is resyncing (not sure why):
>
> cat /proc/mdstat
> =A0Personalities : [raid10] [raid0] [raid1] [raid6] [raid5] [raid4] [=
linear]
> =A0md0 : active raid1 sda1[0] sdd1[3] sdc1[2] sdb1[1]
> =A0 =A0 =A0 160604 blocks super 1.0 [4/4] [UUUU]
>
> =A0md1 : active raid10 sda2[0] sdd2[3] sdc2[2] sdb2[1]
> =A0 =A0 =A0 1953198080 blocks super 1.1 256K chunks 2 far-copies [4/4=
] [UUUU]
> =A0 =A0 =A0 [=3D=3D=3D=3D>................] =A0resync =3D 23.8% (4650=
07616/1953198080)
> finish=3D214.8min speed=3D115452K/sec
>
> =A0unused devices: <none>
>
>
> _Something_ happened at that system upgrade. =A0My mistake for not
> paying closer attention to what was going on. =A0My goal is to not le=
t
> that happen again.
>
> Knowing that I'm not providing any helpful detail -- I don't have it
> atm -- can anyone speculate as to what might have happened @ the sys
> update to cause this? =A0If possible, I'd like to start with some clu=
e
> as to what I'm watching out for.
>
> Thanks,
>
> BenDJ
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
