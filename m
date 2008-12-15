From: Kevin Shanahan <kmshanah@disenchant.net>
Subject: Re: Help recovering RAID6 failure
Date: Tue, 16 Dec 2008 09:07:53 +1030
Message-ID: <20081215223753.GG1749@cubit>
References: <20081215220307.GE1749@cubit> <18758.55029.597319.376426@notabene.brown> <20081215222522.GF1749@cubit>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081215222522.GF1749@cubit>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Dec 16, 2008 at 08:55:22AM +1030, Kevin Shanahan wrote:
> On Tue, Dec 16, 2008 at 09:15:17AM +1100, Neil Brown wrote:
> > On Tuesday December 16, kmshanah@disenchant.net wrote:
> > > hermes:~# mdadm -A /dev/md5 /dev/sd[cefghijk]1
> > > mdadm: failed to RUN_ARRAY /dev/md5: Input/output error
> > 
> > Try adding --force to over-ride apparent errors, and --verbose to help
> > you see what is happening.
> 
> Hrm, force doesn't seem to help. Here's the verbose output:
> 
> hermes:~# mdadm -A --force --verbose /dev/md5 /dev/sd[cefghijk]1
> mdadm: looking for devices for /dev/md5
> mdadm: /dev/sdc1 is identified as a member of /dev/md5, slot 8.
> mdadm: /dev/sde1 is identified as a member of /dev/md5, slot 0.
> mdadm: /dev/sdf1 is identified as a member of /dev/md5, slot 1.
> mdadm: /dev/sdg1 is identified as a member of /dev/md5, slot 2.
> mdadm: /dev/sdh1 is identified as a member of /dev/md5, slot 6.
> mdadm: /dev/sdi1 is identified as a member of /dev/md5, slot 5.
> mdadm: /dev/sdj1 is identified as a member of /dev/md5, slot 4.
> mdadm: /dev/sdk1 is identified as a member of /dev/md5, slot 3.
> mdadm: added /dev/sdf1 to /dev/md5 as 1
> mdadm: added /dev/sdg1 to /dev/md5 as 2
> mdadm: added /dev/sdk1 to /dev/md5 as 3
> mdadm: added /dev/sdj1 to /dev/md5 as 4
> mdadm: added /dev/sdi1 to /dev/md5 as 5
> mdadm: added /dev/sdh1 to /dev/md5 as 6
> mdadm: no uptodate device for slot 7 of /dev/md5
> mdadm: added /dev/sdc1 to /dev/md5 as 8
> mdadm: no uptodate device for slot 9 of /dev/md5
> mdadm: added /dev/sde1 to /dev/md5 as 0
> mdadm: failed to RUN_ARRAY /dev/md5: Input/output error

Oh, and here's what gets added to dmesg after running that command:

md: bind<sdf1>
md: bind<sdg1>
md: bind<sdk1>
md: bind<sdj1>
md: bind<sdi1>
md: bind<sdh1>
md: bind<sdc1>
md: bind<sde1>
md: md5: raid array is not clean -- starting background reconstruction
raid5: device sde1 operational as raid disk 0
raid5: device sdc1 operational as raid disk 8
raid5: device sdh1 operational as raid disk 6
raid5: device sdi1 operational as raid disk 5
raid5: device sdj1 operational as raid disk 4
raid5: device sdk1 operational as raid disk 3
raid5: device sdg1 operational as raid disk 2
raid5: device sdf1 operational as raid disk 1
raid5: cannot start dirty degraded array for md5
RAID5 conf printout:
 --- rd:10 wd:8
 disk 0, o:1, dev:sde1
 disk 1, o:1, dev:sdf1
 disk 2, o:1, dev:sdg1
 disk 3, o:1, dev:sdk1
 disk 4, o:1, dev:sdj1
 disk 5, o:1, dev:sdi1
 disk 6, o:1, dev:sdh1
 disk 8, o:1, dev:sdc1
raid5: failed to run raid set md5
md: pers->run() failed ...

This is run on Linux 2.6.26.9, mdadm 2.6.7.1 (Debian)

Cheers,
Kevin.
