From: BERNARD JOHN ZOLP <bjzolp@students.wisc.edu>
Subject: Re: RE: RAID5 Not coming back up after crash
Date: Mon, 29 Nov 2004 14:56:58 -0600
Message-ID: <30b0335be6.35be630b03@wiscmail.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-language: en
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Just a few follow up questions before I dive into this.  Will mdadm work
with a RAID setup created with the older raidtools package that came
with my SuSE installation?
  Assuming the drive with bad blocks is not getting worse, dont think it
is -- but you never know, could I map them out by writing to those
sectors with dd and then running the command to bring the array back
online?  Or should I wait for the RMA of the flakey drive and dd_rescue
to the new one and bring that up?

Thanks again,
bjz

----- Original Message -----
From: Guy <bugzilla@watkins-home.com>
Date: Monday, November 29, 2004 11:40 am
Subject: RE: RAID5 Not coming back up after crash

> You can recover, but not with bad blocks.
> 
> This command should get your array back on-line:
> mdadm -A /dev/md0 --force /dev/hda1 /dev/hdc1 /dev/hdd1 /dev/hdi1 
> /dev/hdj1
> But, as soon as md reads a bad block it will fail the disk and your 
> arraywill be off-line.
> 
> If you have an extra disk, you could attempt to copy the disk 
> first, then
> replace the disk with the read error with the copy.
> 
> dd_rescue can copy a disk with read errors.
> 
> Also, it is common for a disk to grow bad spots over time.  These 
> bad spots
> (sectors) can be re-mapped by the drive to a spare sector.  This re-
> mappingwill occur when an attempt is made to write to the bad 
> sector.  So, you can
> repair your disk by writing to the bad sectors.  But, be careful 
> not to
> overwrite good data.  I have done this using dd.  First I found the 
> badsector with dd, then I wrote to the 1 bad sector with dd.  I 
> would need to
> refer to the man page to do it again, so I can't explain it here at 
> thistime.  It is not really hard, but 1 small mistake, and "that's 
> it man, game
> over man, game over".
> 
> Guy
> 
> 
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of B. J. Zolp
> Sent: Monday, November 29, 2004 11:33 AM
> To: linux-raid@vger.kernel.org
> Subject: RAID5 Not coming back up after crash
> 
> I have a RAID5 setup on my fileserver using disks hda1 hdb1 hdc1 
> hdd1 
> hdi1 and hdj1.  Yesterday I started moving a large chunk of files 
> ~80GB 
> from this array to a stand alone drive in the system and about 
> halfway 
> through the mv I got a ton of PERMISSION DENIED errors some of the 
> remaining files left to be moved and the move process quit.  I did 
> a ls 
> of the raid directory and got PERMISSION DENIED on the same files 
> that 
> errored out on the mv while some of the other files looked fine.  I 
> figured it might be a good idea to take the raid down and back up 
> again 
> (probably a mistake) and I could not reboot the machine without 
> physically turning it off as some processes were hung.  Upon 
> booting 
> back up, the raid did not come online stating that hdj1 was kicked 
> due 
> to inconsistency.  Additionally hdb1 is listed as offline too.  So 
> I 
> have 2 drives that are not cooperating.  I have a hunch hdb1 might 
> have 
> not been working for some time.
> 
> I found some info stating that if you mark the drive that failed 
> first 
> as "failed-drive" and try a  "mkraid --force --dangerous-no-resync 
> /dev/md0" then I might have some luck getting my files back.  From 
> my 
> logs I can see that all the working drives have event counter: 
> 00000022 
> and hdj1 has event counter: 00000021 and hdb1 has event counter: 
> 00000001.  Does this mean that hdb1 failed a log time ago or is 
> this 
> difference in event counters likely within a few minutes fo each 
> other?  
> I just ran badblocks on both hdb1 and hdj1 and found 1 bad block on 
> hdb1 
> and about 15 on hdj1, would that be enough to cause my raid to get 
> this 
> out of whack?  In any case I plan to replace those drives, but 
> would the 
> method above be the best route once I have copied the raw data to 
> the 
> new drives in order to bring my raid back up?
> 
> 
> Thanks,
> 
> bjz
> 
> here is my log from when I run raidstart /dev/md0:
> 
> Nov 29 10:10:19 orion kernel:  [events: 00000022]
> Nov 29 10:10:19 orion last message repeated 3 times
> Nov 29 10:10:19 orion kernel:  [events: 00000021]
> Nov 29 10:10:19 orion kernel: md: autorun ...
> Nov 29 10:10:19 orion kernel: md: considering hdj1 ...
> Nov 29 10:10:19 orion kernel: md:  adding hdj1 ...
> Nov 29 10:10:19 orion kernel: md:  adding hdi1 ...
> Nov 29 10:10:19 orion kernel: md:  adding hdd1 ...
> Nov 29 10:10:19 orion kernel: md:  adding hdc1 ...
> Nov 29 10:10:19 orion kernel: md:  adding hda1 ...
> Nov 29 10:10:19 orion kernel: md: created md0
> Nov 29 10:10:19 orion kernel: md: bind<hda1,1>
> Nov 29 10:10:19 orion kernel: md: bind<hdc1,2>
> Nov 29 10:10:19 orion kernel: md: bind<hdd1,3>
> Nov 29 10:10:19 orion kernel: md: bind<hdi1,4>
> Nov 29 10:10:19 orion kernel: md: bind<hdj1,5>
> Nov 29 10:10:19 orion kernel: md: running: 
> <hdj1><hdi1><hdd1><hdc1><hda1>Nov 29 10:10:19 orion kernel: md: 
> hdj1's event counter: 00000021
> Nov 29 10:10:19 orion kernel: md: hdi1's event counter: 00000022
> Nov 29 10:10:19 orion kernel: md: hdd1's event counter: 00000022
> Nov 29 10:10:19 orion kernel: md: hdc1's event counter: 00000022
> Nov 29 10:10:19 orion kernel: md: hda1's event counter: 00000022
> Nov 29 10:10:19 orion kernel: md: superblock update time 
> inconsistency 
> -- using the most recent one
> Nov 29 10:10:19 orion kernel: md: freshest: hdi1
> Nov 29 10:10:19 orion kernel: md0: kicking faulty hdj1!
> Nov 29 10:10:19 orion kernel: md: unbind<hdj1,4>
> Nov 29 10:10:19 orion kernel: md: export_rdev(hdj1)
> Nov 29 10:10:19 orion kernel: md: md0: raid array is not clean -- 
> starting background reconstruction
> Nov 29 10:10:19 orion kernel: md0: max total readahead window set 
> to 2560k
> Nov 29 10:10:19 orion kernel: md0: 5 data-disks, max readahead per 
> data-disk: 512k
> Nov 29 10:10:19 orion kernel: raid5: device hdi1 operational as 
> raid disk 4
> Nov 29 10:10:19 orion kernel: raid5: device hdd1 operational as 
> raid disk 3
> Nov 29 10:10:19 orion kernel: raid5: device hdc1 operational as 
> raid disk 2
> Nov 29 10:10:19 orion kernel: raid5: device hda1 operational as 
> raid disk 0
> Nov 29 10:10:19 orion kernel: raid5: not enough operational devices 
> for 
> md0 (2/6 failed)
> Nov 29 10:10:19 orion kernel: RAID5 conf printout:
> Nov 29 10:10:19 orion kernel:  --- rd:6 wd:4 fd:2
> Nov 29 10:10:19 orion kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 
> dev:hda1Nov 29 10:10:19 orion kernel:  disk 1, s:0, o:0, n:1 rd:1 
> us:1 dev:[dev 
> 00:00]
> Nov 29 10:10:19 orion kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 
> dev:hdc1Nov 29 10:10:19 orion kernel:  disk 3, s:0, o:1, n:3 rd:3 
> us:1 dev:hdd1
> Nov 29 10:10:19 orion kernel:  disk 4, s:0, o:1, n:4 rd:4 us:1 
> dev:hdi1Nov 29 10:10:19 orion kernel:  disk 5, s:0, o:0, n:5 rd:5 
> us:1 dev:[dev 
> 00:00]
> Nov 29 10:10:19 orion kernel: raid5: failed to run raid set md0
> Nov 29 10:10:19 orion kernel: md: pers->run() failed ...
> Nov 29 10:10:19 orion kernel: md :do_md_run() returned -22
> Nov 29 10:10:19 orion kernel: md: md0 stopped.
> Nov 29 10:10:19 orion kernel: md: unbind<hdi1,3>
> Nov 29 10:10:19 orion kernel: md: export_rdev(hdi1)
> Nov 29 10:10:19 orion kernel: md: unbind<hdd1,2>
> Nov 29 10:10:19 orion kernel: md: export_rdev(hdd1)
> Nov 29 10:10:19 orion kernel: md: unbind<hdc1,1>
> Nov 29 10:10:19 orion kernel: md: export_rdev(hdc1)
> Nov 29 10:10:19 orion kernel: md: unbind<hda1,0>
> Nov 29 10:10:19 orion kernel: md: export_rdev(hda1)
> Nov 29 10:10:19 orion kernel: md: ... autorun DONE.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-
> raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> -- 
> No virus found in this incoming message.
> Checked by AVG Anti-Virus.
> Version: 7.0.289 / Virus Database: 265.4.3 - Release Date: 11/26/2004
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-
> raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
