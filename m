From: Bernhard Dobbels <Bernhard@Dobbels.com>
Subject: Re: raid5+ lvm2 disaster
Date: Fri, 16 Jul 2004 13:02:04 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40F7B5AC.7090408@dobbels.com>
References: <40EEFD38.8080805@dobbels.com>   <1089415087.17625.200079546@webmail.messagingengine.com> <1089671606.706.200220968@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1089671606.706.200220968@webmail.messagingengine.com>
To: "Matthew (RAID)" <RAID@lists.elvey.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hmm, tried, but no good.
Now I don't get the raid up anymore. Mentally I've already accepted that 
  my data is lost, but the engineer in me wants to do the impossible.

any help is more than welcome.

So, Ive gathered some more info.
I did a mkraid with following raidtab (which is still the same as I 
originally used, besides the failed-disk line then) :

raiddev /dev/md0
         raid-level      5
         nr-raid-disks   3
         nr-spare-disks  0
         persistent-superblock   1
         chunk-size              32
         parity-algorithm        left-symmetric

         device  /dev/hdc1
         raid-disk 0
         device  /dev/hde1
         failed-disk 1
         device  /dev/hdg1
         raid-disk 2


Then /prc/mdstat says the raid is in 'inactive state'.
The syslog output is:
Jul 16 12:52:23 localhost kernel: md: autorun ...
Jul 16 12:52:23 localhost kernel: md: considering hde1 ...
Jul 16 12:52:23 localhost kernel: md:  adding hde1 ...
Jul 16 12:52:23 localhost kernel: md:  adding hdg1 ...
Jul 16 12:52:23 localhost kernel: md:  adding hdc1 ...
Jul 16 12:52:23 localhost kernel: md: created md0
Jul 16 12:52:23 localhost kernel: md: bind<hdc1>
Jul 16 12:52:23 localhost kernel: md: bind<hdg1>
Jul 16 12:52:23 localhost kernel: md: bind<hde1>
Jul 16 12:52:23 localhost kernel: md: running: <hde1><hdg1><hdc1>
Jul 16 12:52:23 localhost kernel: md: kicking non-fresh hde1 from array!
Jul 16 12:52:23 localhost kernel: md: unbind<hde1>
Jul 16 12:52:23 localhost kernel: md: export_rdev(hde1)
Jul 16 12:52:23 localhost kernel: raid5: device hdg1 operational as raid 
disk 2
Jul 16 12:52:23 localhost kernel: RAID5 conf printout:
Jul 16 12:52:23 localhost kernel:  --- rd:3 wd:1 fd:2
Jul 16 12:52:23 localhost kernel:  disk 2, o:1, dev:hdg1
Jul 16 12:52:23 localhost kernel: md :do_md_run() returned -22
Jul 16 12:52:23 localhost kernel: md: md0 stopped.
Jul 16 12:52:23 localhost kernel: md: unbind<hdg1>
Jul 16 12:52:23 localhost kernel: md: export_rdev(hdg1)
Jul 16 12:52:23 localhost kernel: md: unbind<hdc1>
Jul 16 12:52:23 localhost kernel: md: export_rdev(hdc1)
Jul 16 12:52:23 localhost kernel: md: ... autorun DONE.


The output of lsraid contracticts this. Is there any way in putting hdc1 
back as disk 1 instead of spare (even manually by changing bits on the 
disk??) It still says I have two working disks.

viking:/mnt/new# lsraid -D -p -l
[dev 22, 1] /dev/hdc1:
         md version              = 0.90.0
         superblock uuid         = 829542B9.3737417C.D102FD21.18FFE273
         md minor number         = 0
         created                 = 1087242684 (Mon Jun 14 21:51:24 2004)
         last updated            = 1089375813 (Fri Jul  9 14:23:33 2004)
         raid level              = 5
         chunk size              = 32 KB
         apparent disk size      = 195358336 KB
         disks in array          = 3
         required disks          = 3
         active disks            = 1
         working disks           = 2
         failed disks            = 2
         spare disks             = 1
         position in disk list   = 4
         position in md device   = -1
         state                   = spare



[dev 33, 1] /dev/hde1:
         md version              = 0.90.0
         superblock uuid         = 829542B9.3737417C.D102FD21.18FFE273
         md minor number         = 0
         created                 = 1087242684 (Mon Jun 14 21:51:24 2004)
         last updated            = 1089149455 (Tue Jul  6 23:30:55 2004)
         raid level              = 5
         chunk size              = 32 KB
         apparent disk size      = 195358336 KB
         disks in array          = 3
         required disks          = 3
         active disks            = 2
         working disks           = 3
         failed disks            = 0
         spare disks             = 1
         position in disk list   = 3
         position in md device   = -1
         state                   = failed

[dev 34, 1] /dev/hdg1:
         md version              = 0.90.0
         superblock uuid         = 829542B9.3737417C.D102FD21.18FFE273
         md minor number         = 0
         created                 = 1087242684 (Mon Jun 14 21:51:24 2004)
         last updated            = 1089375813 (Fri Jul  9 14:23:33 2004)
         raid level              = 5
         chunk size              = 32 KB
         apparent disk size      = 195358336 KB
         disks in array          = 3
         required disks          = 3
         active disks            = 1
         working disks           = 2
         failed disks            = 2
         spare disks             = 1
         position in disk list   = 2
         position in md device   = 2
         state                   = good


Matthew (RAID) wrote:
> Hmm. I posted the following (from my subbed addr) but it never appeared
> - in my inbox or on MARC.
> Perhaps I hit a keyword; reposting with some tweaks.
> 
> On Fri, 09 Jul 2004 16:18:07 -0700, "Matthew (RAID)"
> <RAID@lists.elvey.com> said:
> 
>>One more thing - run hdparm to check that the DMA settings are
>>consistent - the same on all drives.
>>Switch to the most conservative settings (the slowest ones).
>>If they're not the same on all drives, I've heard (on /.) that it can
>>cause some of the problems you're seeing.
>>
>>My original reply below - it just went to Bernhard; I didn't check the
>>addressing.
>>
>>Let us know how things go.
>>
>>PS Any ideas on my post?
>>
>>On Fri, 09 Jul 2004 22:16:56 +0200, "Bernhard Dobbels"
>><Bernhard@Dobbels.com> said:
>>
>>
>>
>>>><snip>
>>
>>
>>>>viking:/home/bernhard# cat /etc/raidtab
>>>>raiddev /dev/md0
>>>>         raid-level      5
>>>>         nr-raid-disks   3
>>>>         nr-spare-disks  0
>>>>         persistent-superblock   1
>>>>         parity-algorithm        left-symmetric
>>>>
>>>>         device  /dev/hdc1
>>>>         raid-disk 0
>>>>         device  /dev/hde1
>>>>         failed-disk 1
>>>>         device  /dev/hdg1
>>>>         raid-disk 2
>>
>>
>>Hmm. So the array is c+e+g, which think they are spare, failed, and
>>good, respectively.
>>The array won't be accessible unless at least two are good.
>>
>>I wonder if running mkraid with --really-force when e was marked failed
>>was a good idea; hopefully it didn't make things worse. 
>>
>>
>>
>>>>
>>>>viking:/home/bernhard# mkraid --really-force /dev/md0
>>>>DESTROYING the contents of /dev/md0 in 5 seconds, Ctrl-C if unsure!
>>>>handling MD device /dev/md0
>>>>analyzing super-block
>>>>disk 0: /dev/hdc1, 195358401kB, raid superblock at 195358336kB
>>>>disk 1: /dev/hde1, failed
>>>>disk 2: /dev/hdg1, 195358401kB, raid superblock at 195358336kB
>>>>/dev/md0: Invalid argument
>>>>
>>>>viking:/home/bernhard# raidstart /dev/md0
>>>>/dev/md0: Invalid argument
>>>>
>>>>
>>>>viking:/home/bernhard# cat /proc/mdstat
>>>>Personalities : [raid1] [raid5]
>>>>md0 : inactive hdg1[2] hdc1[0]
>>>>       390716672 blocks
>>>>unused devices: <none>
>>>>viking:/home/bernhard# pvscan -v
>>>>     Wiping cache of LVM-capable devices
>>>>     Wiping internal cache
>>>>     Walking through all physical volumes
>>>>   Incorrect metadata area header checksum
>>>>   Found duplicate PV uywoDlobnH0pbnr09dYuUWqB3A5kkh8M: using /dev/hdg1 
>>>>not /dev/hdc1
>>>>   Incorrect metadata area header checksum
>>>>   Incorrect metadata area header checksum
>>>>   Incorrect metadata area header checksum
>>>>   Found duplicate PV uywoDlobnH0pbnr09dYuUWqB3A5kkh8M: using /dev/hdg1 
>>>>not /dev/hdc1
>>>>   PV /dev/hdc1   VG data_vg   lvm2 [372,61 GB / 1,61 GB free]
>>>>   PV /dev/hda1                lvm2 [4,01 GB]
>>>>   Total: 2 [376,63 GB] / in use: 1 [372,61 GB] / in no VG: 1 [4,01 GB]
>>
>>
>>Yow.  
>>
>>I'm wondering if editing raidtab to make e (/dev/hde1) not failed and
>>trying mkraid again is a good idea.
>>
>>Any idea why c would think it was a spare?  That's pretty strange.
>>
> 
> 
> Anyway, I'm no expert - I just posted a call for help:
>  
> http://marc.theaimsgroup.com/?l=linux-raid&m=108932298006669&w=2 
> 
> that went unanswered.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
