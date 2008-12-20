From: Kevin Shanahan <kmshanah@disenchant.net>
Subject: Re: Read errors and SMART tests
Date: Sat, 20 Dec 2008 19:39:09 +1030
Message-ID: <20081220090909.GO1749@cubit>
References: <20081220013043.GM1749@cubit> <A20315AE59B5C34585629E258D76A97C031B1B62@34093-C3-EVS3.exchange.rackspace.com> <20081220052244.GN1749@cubit> <A20315AE59B5C34585629E258D76A97C031B1B64@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <A20315AE59B5C34585629E258D76A97C031B1B64@34093-C3-EVS3.exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Dec 20, 2008 at 12:54:24AM -0600, David Lethe wrote:
> This particular test terminates when the FIRST bad block is found.
> It is not an indication of a drive in stress or immediate
> replacement.  I don't have the desire or time to look up how many
> reserved blocks that disk has, but I wouldn't be surprised if it was
> well over 10,000.  The count is certainly documented in the product
> manual, but not necessarily the data sheet, and certainly not on the
> outside of the box.  (I'm curious, if you look it up, please post
> it).

Sorry, I didn't have any luck finding that info.

Data sheet - http://www.samsung.com/global/system/business/hdd/prdmodel/2008/8/19/525716F1_DT_R4.8.pdf
Product manual - http://downloadcenter.samsung.com/content/UM/200704/20070419200104171_3.5_Install_Gudie_Eng_200704.pdf

> Time for you to run full consistency check/repairs.

You mean array consistency? Yeah, I've done that. This drive was
removed, raid superblock zeroed and then re-added to the array on
Thursday morning, so the entire drive had been re-written only
recently.

Dec 18 04:16:04 hermes kernel: md: bind<sdd1>
Dec 18 04:16:08 hermes kernel: RAID5 conf printout:
Dec 18 04:16:08 hermes kernel:  --- rd:10 wd:9
Dec 18 04:16:08 hermes kernel:  disk 0, o:1, dev:sde1
Dec 18 04:16:08 hermes kernel:  disk 1, o:1, dev:sdf1
Dec 18 04:16:08 hermes kernel:  disk 2, o:1, dev:sdg1
Dec 18 04:16:08 hermes kernel:  disk 3, o:1, dev:sdk1
Dec 18 04:16:08 hermes kernel:  disk 4, o:1, dev:sdj1
Dec 18 04:16:08 hermes kernel:  disk 5, o:1, dev:sdi1
Dec 18 04:16:08 hermes kernel:  disk 6, o:1, dev:sdh1
Dec 18 04:16:08 hermes kernel:  disk 7, o:1, dev:sdd1
Dec 18 04:16:08 hermes kernel:  disk 8, o:1, dev:sdc1
Dec 18 04:16:08 hermes kernel:  disk 9, o:1, dev:sdl1
Dec 18 04:16:08 hermes mdadm[1949]: RebuildStarted event detected on md device /dev/md5
Dec 18 04:16:08 hermes kernel: md: recovery of RAID array md5
Dec 18 04:16:08 hermes kernel: md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
Dec 18 04:16:08 hermes kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
Dec 18 04:16:08 hermes kernel: md: using 128k window, over a total of 976759936 blocks.
Dec 18 08:41:08 hermes mdadm[1949]: Rebuild20 event detected on md device /dev/md5
Dec 18 11:46:08 hermes mdadm[1949]: Rebuild40 event detected on md device /dev/md5
Dec 18 14:35:08 hermes mdadm[1949]: Rebuild60 event detected on md device /dev/md5
Dec 18 17:20:08 hermes mdadm[1949]: Rebuild80 event detected on md device /dev/md5
Dec 18 19:58:05 hermes kernel: md: md5: recovery done.
Dec 18 19:58:05 hermes kernel: RAID5 conf printout:
Dec 18 19:58:05 hermes kernel:  --- rd:10 wd:10
Dec 18 19:58:05 hermes kernel:  disk 0, o:1, dev:sde1
Dec 18 19:58:05 hermes kernel:  disk 1, o:1, dev:sdf1
Dec 18 19:58:05 hermes kernel:  disk 2, o:1, dev:sdg1
Dec 18 19:58:05 hermes kernel:  disk 3, o:1, dev:sdk1
Dec 18 19:58:05 hermes kernel:  disk 4, o:1, dev:sdj1
Dec 18 19:58:05 hermes kernel:  disk 5, o:1, dev:sdi1
Dec 18 19:58:05 hermes kernel:  disk 6, o:1, dev:sdh1
Dec 18 19:58:05 hermes kernel:  disk 7, o:1, dev:sdd1
Dec 18 19:58:05 hermes kernel:  disk 8, o:1, dev:sdc1
Dec 18 19:58:05 hermes kernel:  disk 9, o:1, dev:sdl1
Dec 18 19:58:05 hermes mdadm[1949]: RebuildFinished event detected on md device /dev/md5
Dec 18 19:58:05 hermes mdadm[1949]: SpareActive event detected on md device /dev/md5, component device /dev/sdd1

And then, e.g.

Dec 18 22:17:44 hermes kernel: ata4.00: exception Emask 0x0 SAct 0xc3f SErr 0x0 action 0x0
Dec 18 22:17:44 hermes kernel: ata4.00: irq_stat 0x40000008
Dec 18 22:17:44 hermes kernel: ata4.00: cmd 60/58:50:c7:b1:c6/00:00:1e:00:00/40 tag 10 ncq 45056 in
Dec 18 22:17:44 hermes kernel:          res 41/40:00:ca:b1:c6/00:00:1e:00:00/40 Emask 0x409 (media error) <F>
Dec 18 22:17:44 hermes kernel: ata4.00: status: { DRDY ERR }
Dec 18 22:17:44 hermes kernel: ata4.00: error: { UNC }
Dec 18 22:17:44 hermes kernel: ata4.00: configured for UDMA/133
Dec 18 22:17:44 hermes kernel: ata4: EH complete
Dec 18 22:17:44 hermes kernel: sd 3:0:0:0: [sdd] 1953525168 512-byte hardware sectors (1000205 MB)
Dec 18 22:17:44 hermes kernel: sd 3:0:0:0: [sdd] Write Protect is off
Dec 18 22:17:44 hermes kernel: sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
Dec 18 22:17:44 hermes kernel: sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

There are lots of these.

hermes:~# zgrep UNC /var/log/syslog{.1.gz,.0,} | wc -l
385

Of the remaining drives, SMART attributes for /dev/sd[cghijkl] all show:

  196 Reallocated_Event_Count 0x0032   100   100   000    Old_age   Always       -       0
  197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       0

/dev/sde shows:

  196 Reallocated_Event_Count 0x0032   100   100   000    Old_age   Always       -       0
  197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       3

/dev/sdf shows:

  196 Reallocated_Event_Count 0x0032   100   100   000    Old_age   Always       -       2
  197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       0

Unfortunately the original /dev/sdd isn't currently attached, but I'll
hook that up on Monday and check. I'd expect to see some high numbers
there.

> These errors could be
> Result of something relatively benign, like unexpected power loss.

Sorry, are you saying that about the errors from libata layer or just
the errors from the md layer?

Cheers,
Kevin.
