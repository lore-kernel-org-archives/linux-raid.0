From: "fibreraid@gmail.com" <fibreraid@gmail.com>
Subject: Re: ANNOUNCE: mdadm 3.1.4 - A tool for managing Soft RAID under Linux
Date: Thu, 16 Sep 2010 23:33:36 -0400
Message-ID: <AANLkTimcC=h47qjkztW3cJ3Lh294Sbj6X=o3Zwfbh+E8@mail.gmail.com>
References: <19580.38720.309122.572004@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19580.38720.309122.572004@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

Thank you for the 3.1.4 mdadm release, but I am seeing three immediate
issues with it. I upgraded to 3.1.4 from 3.1.3 plus the patch to deal
with incremental assembly of spares at system reboot. Now, new md's
are coming back with strange device #'s and coming back online as
"auto-read-only". I have duplicated these issues on multiple systems
as well as on a virtual machine.

My machine configuration is as follows:

Ubuntu 10.04 Lucid 64-bit up to date
8GB RAM
Dual quad-core CPUs
12 x Seagate Cheetah 15K.7 hard drives
Drives connected with LSI 3Gbps SAS HBA


To reproduce the issues:

1. Create /dev/md0 with RAID level 6, 11 active drives, 1 hot-spare,
64K chunk size, v1.2 superblock, run immediately
2. After a few minutes of syncing, reboot the system.
3. When Ubuntu comes back up, /proc/mdstat will report:

Personalities : [raid6] [raid5] [raid4] [linear] [multipath] [raid0]
[raid1] [raid10]
md127 : active (auto-read-only) raid6 sdd1[2] sdl1[10] sdk1[9] sdb1[0]
sdj1[8] sdf1[4] sde1[3] sdg1[5] sdc1[1] sdh1[6] sdi1[7] sdm1[11](S)
      943695936 blocks super 1.2 level 6, 64k chunk, algorithm 2
[11/11] [UUUUUUUUUUU]
       resync=3DPENDING

Please note the three issues:
A) md marked as "auto-read-only". This never happened with 3.1.3.
B) md comes back up as md127 eventhough it is the only md in the
system. I've never seen ever with mdadm.
C) md comes back with "resync=3DPENDING" instead of automatically
resyncing. mdadm 3.1.3 would auto resync.

Please note that issues A and B also occur even if the system is
rebooted AFTER RAID synchronization is fully completed. Running mdadm
-R /dev/md0 produces an error about the device being busy but does
appear to clear the auto-read-only designation. I also tested with
this three md's. Surprisingly, md0 came back as md127, md1 as md126,
and md2 as md125, and of course, all auto-read-only.

I am happy to run any tests you like as these issues are very quick
and easy to reproduce. They seem like serious regressions or perhaps
some incompatibility of mdadm 3.1.4 with Ubuntu. I await your
guidance. Thank you Neil!


Best
-Tommy






On Tue, Aug 31, 2010 at 1:46 AM, Neil Brown <neilb@suse.de> wrote:
>
> I am pleased to announce the availability of
> =A0 mdadm version 3.1.4
>
> It is available at the usual places:
> =A0 countrycode=3Dxx.
> =A0 http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
> and via git at
> =A0 git://neil.brown.name/mdadm
> =A0 http://neil.brown.name/git?p=3Dmdadm
>
> This is a bugfix/stability release over 3.1.3.
> 3.1.3 had a couple of embarrasing regressions and a couple of other
> issues surfaces which had easy fixes so I decided to make a 3.1.4
> release after all.
>
> Two fixes related to configs that aren't using udev:
> =A0 - Don't remove md devices which 'standard' names on --stop
> =A0 - Allow dev_open to work on read-only /dev
> And fixed regressions:
> =A0 - Allow --incremental to add spares to an array
> =A0 - Accept --no-degraded as a deprecated option rather than
> =A0 =A0 =A0 =A0 =A0 =A0throwing an error
> =A0 - Return correct success status when --incrmental assembling
> =A0 =A0 a container which does not yet have enough devices.
> =A0 - Don't link mdadm with pthreads, only mdmon needs it.
> =A0 - Fix compiler warning due to bad use of snprintf
>
> This release is believed to be stable and you should feel free to
> upgrade to 3.1.4
>
> It is expected that the next release will be 3.2 with a number of new
> features.
>
> NeilBrown 31st August 2010
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
