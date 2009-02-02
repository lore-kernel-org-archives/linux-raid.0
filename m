From: whollygoat@letterboxes.org
Subject: Re: some ?? re failed disk and resyncing of array
Date: Sun, 01 Feb 2009 17:47:53 -0800
Message-ID: <1233539273.12800.1297953007@webmail.messagingengine.com>
References: <1233389816.28363.1297740563@webmail.messagingengine.com>
 <49842A1E.1090105@dgreaves.com>
 <1233403388.29916.1297756217@webmail.messagingengine.com>
 <4985FAF1.2090208@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4985FAF1.2090208@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Bill Davidsen <davidsen@tmr.com>, David Greaves <david@dgreaves.com>
List-Id: linux-raid.ids


On Sun, 01 Feb 2009 14:41:37 -0500, "Bill Davidsen" <davidsen@tmr.com>
said:
> whollygoat@letterboxes.org wrote:
> > On Sat, 31 Jan 2009 10:38:22 +0000, "David Greaves" <david@dgreaves.com>
> > said:
> >   
> >> whollygoat@letterboxes.org wrote:
> >>     
> >>> On a boot a couple of days ago, mdadm failed a disk and
> >>> started resyncing to spare (raid5, 6 drives, 5 active, 1
> >>> spare).  smartctl -H <disk> returned info (can't remember
> >>> the exact text) that made me suspect the drive was
> >>> fine, but the data connection was bad.  Sure enough the
> >>> data cable was damaged.  Replaced the cable and smartctl
> >>> sees the disk just fine and reports no errors.
> >>>
> >>> - I'd like to readd the drive as a spare.  Is it enough
> >>> to "mdadm --add /dev/hdk" or do I need to prep the drive to
> >>> remove any data that said where it previously belonged
> >>> in the array?
> >>>       
> >> That should work.
> >> Any issues and you can zero the superblock (man mdadm)
> >> No need to zero the disk.
> >>     
> >
> > Would --re-add be better?
> >
> >   
> I don't think do. And I would zero the superblock. The more detail you 
> put into preventing unwanted autodetection the fewer learning 
> experiences you will have.

Will do
> > fly:~# mdadm -D /dev/md0
[snip]

> >    Raid Devices : 5
> >   Total Devices : 5
> > Preferred Minor : 0
> >     Persistence : Superblock is persistent
> >
> >   Intent Bitmap : Internal
> >
> >     Update Time : Fri Jan 30 15:52:01 2009
> >           State : active
> >  Active Devices : 5
> > Working Devices : 5
> >  Failed Devices : 0
> >   Spare Devices : 0

[snip]
> >
> >     Number   Major   Minor   RaidDevice State
> >        0      33        1        0      active sync   /dev/hde1
> >        1      34        1        1      active sync   /dev/hdg1
> >        2      56        1        2      active sync   /dev/hdi1
> >        5      89        1        3      active sync   /dev/hdo1
> >        6      88        1        4      active sync   /dev/hdm1
> >
> >
> > fly:~# mdadm -E /dev/hdo1

[snip]
> >
> >     Array Slot : 5 (0, 1, 2, failed, failed, 3, 4)
> >    Array State : uuuUu 2 failed
> > --------- end output -------------
> >
> > Why does the "Array Slot" field show 7 slots?  And why
> > does the field "Array State" show 2 failed?  There 
> > ever only were 6 disks in the array.  Only one of those
> > is currently missing.  mdadm -D above doesn't list any
> > failed devices in the "Failed Devices" field.
> >
> >   
> No idea, but did you explicitly remove the failed drive? Was there a 
> failed drive at some time in the past?

No explicit removal.  Maybe I should have.  I let it rebuild
then shutdown to see if it was just something like cabling.
After dealing with the cabling problem and rebooting mdadm -D
didn't show any failed drives, just as above, so it never occurred
to me to remove the drive.

Is there anything I can do to fix the information reported by
mdadm -E <component device>?  Maybe when I add the old drive
as the new spare it will be taken care of?

Thanks,

wg

-- 
  
  whollygoat@letterboxes.org

-- 
http://www.fastmail.fm - The way an email service should be

