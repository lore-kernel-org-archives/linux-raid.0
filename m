From: Wolfram Schlich <lists@schlich.org>
Subject: Re: I just trashed my RAID5 array - recovery possible?
Date: Thu, 20 Mar 2003 08:51:33 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030320075133.ALLYOURBASEAREBELONGTOUS.B4264@bla.fasel.org>
References: <20030320000358.ALLYOURBASEAREBELONGTOUS.A6336@bla.fasel.org> <15993.2378.97234.342504@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <15993.2378.97234.342504@notabene.cse.unsw.edu.au>
To: Linux-RAID mailinglist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

* Neil Brown <neilb@cse.unsw.edu.au> [2003-03-20 01:26]:
> On Thursday March 20, lists@schlich.org wrote:
> > Hi,
> > 
> > I just trashed my RAID5 array. The Promise IDE driver messed up
> > sharing IRQs with a network interface card while writing a file to
> > the array via the mentioned NIC card.
> > Is any recovery possible? I wouldn't care about some lost
> > megabytes... really. Thanks in advance!
> 
> I recommend:
> 	mdadm -A /dev/md1 --force /dev/sd[egik]1

I've just tried that. Looks better than before ;-) Here's the result:
--8<--
 [events: 00000038]
md: bind<hde1,1>
 [events: 0000003a]
md: bind<hdi1,2>
 [events: 0000003a]
md: bind<hdk1,3>
 [events: 0000003a]
md: bind<hdg1,4>
md: hdg1's event counter: 0000003a
md: hdk1's event counter: 0000003a
md: hdi1's event counter: 0000003a
md: hde1's event counter: 00000038
md: superblock update time inconsistency -- using the most recent one
md: freshest: hdg1
md: kicking non-fresh hde1 from array!
md: unbind<hde1,3>
md: export_rdev(hde1)
md1: removing former faulty hde1!
md1: max total readahead window set to 768k
md1: 3 data-disks, max readahead per data-disk: 256k
raid5: device hdg1 operational as raid disk 0
raid5: device hdk1 operational as raid disk 3
raid5: device hdi1 operational as raid disk 2
raid5: md1, not all disks are operational -- trying to recover array
raid5: allocated 4340kB for md1
raid5: raid level 5 set md1 active with 3 out of 4 devices, algorithm 2
RAID5 conf printout:
 --- rd:4 wd:3 fd:1
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:hdg1
 disk 1, s:0, o:0, n:1 rd:1 us:1 dev:[dev 00:00]
 disk 2, s:0, o:1, n:2 rd:2 us:1 dev:hdi1
 disk 3, s:0, o:1, n:3 rd:3 us:1 dev:hdk1
RAID5 conf printout:
 --- rd:4 wd:3 fd:1
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:hdg1
 disk 1, s:0, o:0, n:1 rd:1 us:1 dev:[dev 00:00]
 disk 2, s:0, o:1, n:2 rd:2 us:1 dev:hdi1
 disk 3, s:0, o:1, n:3 rd:3 us:1 dev:hdk1
md: updating md1 RAID superblock on device
md: hdg1 [events: 0000003b]<6>(write) hdg1's sb offset: 117218176
md: recovery thread got woken up ...
md1: no spare disk to reconstruct array! -- continuing in degraded mode
md: recovery thread finished ...
md: hdk1 [events: 0000003b]<6>(write) hdk1's sb offset: 117218176
md: hdi1 [events: 0000003b]<6>(write) hdi1's sb offset: 117218176
raid5: switching cache buffer size, 4096 --> 1024
raid5: switching cache buffer size, 1024 --> 4096
--8<--

And when I try to mount the array:
--8<--
EXT3-fs error (device md(9,1)): ext3_check_descriptors: Block bitmap for group 509 not in group (block 4294967295)!
EXT3-fs: group descriptors corrupted !
--8<--

What should I do now? Raidhotadd the 4th device? Run e2fsck prior to
that or afterwards?
Thanks in advance!
-- 
Wolfram Schlich; Friedhofstr. 8, D-88069 Tettnang; +49-(0)178-SCHLICH
