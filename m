From: Pavel Herrmann <morpheus.ibis@gmail.com>
Subject: Re: data corruption after rebuild
Date: Tue, 19 Jul 2011 18:18:56 +0200
Message-ID: <8745665.3py2GtsBIG@bloomfield>
References: <2073005.NH8LALaxuD@bloomfield> <20110719211240.2578bba6@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110719211240.2578bba6@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday 19 of July 2011 21:12:40 Roman Mamedov wrote:
> Hello,
> 
> On Tue, 19 Jul 2011 15:55:35 +0200
> 
> Pavel Herrmann <morpheus.ibis@gmail.com> wrote:
> > the problem is that the rebuilt array is corrupted. most of the data is
> > fine, but every several MB there is an error (which doesn't look like
> > being caused by a crash), effectively invalidating all data on the
> > drive (about 7TB, mainly HD video)
> 
> Which model of SATA controller/HBA do you use?

4 drives on ahci (ICH10R), 4 drives on sata_mv (adaptec 1430SA)

> Kernel version, mdadm version?

2.6.33-gentoo-r1, mdadm - v3.1.5 - 23rd March 2011

> Anything unusual in SMART reports of any of the drives (e.g. a nonzero UDMA
> CRC Error count)?

one current-pending-sector on the drive that was removed, and one on one more
> 
> > I do monthly scans, so the redundancy syndromes should have been
> > up-to-date, the array is made of 8 disks, the setup is ext4 on lvm on
> > mdraid
> 
> Did you notice any nonzero mismatch_cnt during those scans?

where would I find this?

syslog for last scan is just:

Jul  2 08:40:01 Bloomfield kernel: [83795.157876] md: data-check of RAID array md0
Jul  2 08:40:01 Bloomfield mdadm[2613]: RebuildStarted event detected on md device /dev/md0
Jul  2 09:46:41 Bloomfield mdadm[2613]: Rebuild21 event detected on md device /dev/md0
Jul  2 10:53:21 Bloomfield mdadm[2613]: Rebuild42 event detected on md device /dev/md0
Jul  2 12:00:02 Bloomfield mdadm[2613]: Rebuild61 event detected on md device /dev/md0
Jul  2 13:40:02 Bloomfield mdadm[2613]: Rebuild82 event detected on md device /dev/md0
Jul  2 16:02:46 Bloomfield kernel: [110348.161984] md: md0: data-check done.
Jul  2 16:02:47 Bloomfield mdadm[2613]: RebuildFinished event detected on md device /dev/md0, component device  mismatches found: 72

I presume the nonzero "mismatches found" is a bad thing?

just to mention, all files were fine two dayss ago (I do keep md5sums of all files to check for bit rot)
