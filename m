From: "Matthew (RAID)" <RAID@lists.elvey.com>
Subject: Re: raid5+ lvm2 disaster
Date: Mon, 12 Jul 2004 15:33:26 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1089671606.706.200220968@webmail.messagingengine.com>
References: <40EEFD38.8080805@dobbels.com>
   <1089415087.17625.200079546@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1089415087.17625.200079546@webmail.messagingengine.com>
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hmm. I posted the following (from my subbed addr) but it never appeared
- in my inbox or on MARC.
Perhaps I hit a keyword; reposting with some tweaks.

On Fri, 09 Jul 2004 16:18:07 -0700, "Matthew (RAID)"
<RAID@lists.elvey.com> said:
> One more thing - run hdparm to check that the DMA settings are
> consistent - the same on all drives.
> Switch to the most conservative settings (the slowest ones).
> If they're not the same on all drives, I've heard (on /.) that it can
> cause some of the problems you're seeing.
> 
> My original reply below - it just went to Bernhard; I didn't check the
> addressing.
> 
> Let us know how things go.
> 
> PS Any ideas on my post?
> 
> On Fri, 09 Jul 2004 22:16:56 +0200, "Bernhard Dobbels"
> <Bernhard@Dobbels.com> said:
> 
> 
> >> <snip>
> 
> 
> >> viking:/home/bernhard# cat /etc/raidtab
> >> raiddev /dev/md0
> >>          raid-level      5
> >>          nr-raid-disks   3
> >>          nr-spare-disks  0
> >>          persistent-superblock   1
> >>          parity-algorithm        left-symmetric
> >> 
> >>          device  /dev/hdc1
> >>          raid-disk 0
> >>          device  /dev/hde1
> >>          failed-disk 1
> >>          device  /dev/hdg1
> >>          raid-disk 2
> 
> 
> Hmm. So the array is c+e+g, which think they are spare, failed, and
> good, respectively.
> The array won't be accessible unless at least two are good.
> 
> I wonder if running mkraid with --really-force when e was marked failed
> was a good idea; hopefully it didn't make things worse. 
> 
> 
> >> 
> >> 
> >> viking:/home/bernhard# mkraid --really-force /dev/md0
> >> DESTROYING the contents of /dev/md0 in 5 seconds, Ctrl-C if unsure!
> >> handling MD device /dev/md0
> >> analyzing super-block
> >> disk 0: /dev/hdc1, 195358401kB, raid superblock at 195358336kB
> >> disk 1: /dev/hde1, failed
> >> disk 2: /dev/hdg1, 195358401kB, raid superblock at 195358336kB
> >> /dev/md0: Invalid argument
> >> 
> >> viking:/home/bernhard# raidstart /dev/md0
> >> /dev/md0: Invalid argument
> >> 
> >> 
> >> viking:/home/bernhard# cat /proc/mdstat
> >> Personalities : [raid1] [raid5]
> >> md0 : inactive hdg1[2] hdc1[0]
> >>        390716672 blocks
> >> unused devices: <none>
> >> viking:/home/bernhard# pvscan -v
> >>      Wiping cache of LVM-capable devices
> >>      Wiping internal cache
> >>      Walking through all physical volumes
> >>    Incorrect metadata area header checksum
> >>    Found duplicate PV uywoDlobnH0pbnr09dYuUWqB3A5kkh8M: using /dev/hdg1 
> >> not /dev/hdc1
> >>    Incorrect metadata area header checksum
> >>    Incorrect metadata area header checksum
> >>    Incorrect metadata area header checksum
> >>    Found duplicate PV uywoDlobnH0pbnr09dYuUWqB3A5kkh8M: using /dev/hdg1 
> >> not /dev/hdc1
> >>    PV /dev/hdc1   VG data_vg   lvm2 [372,61 GB / 1,61 GB free]
> >>    PV /dev/hda1                lvm2 [4,01 GB]
> >>    Total: 2 [376,63 GB] / in use: 1 [372,61 GB] / in no VG: 1 [4,01 GB]
> 
> 
> Yow.  
> 
> I'm wondering if editing raidtab to make e (/dev/hde1) not failed and
> trying mkraid again is a good idea.
> 
> Any idea why c would think it was a spare?  That's pretty strange.
> 

Anyway, I'm no expert - I just posted a call for help:
 
http://marc.theaimsgroup.com/?l=linux-raid&m=108932298006669&w=2 

that went unanswered.
