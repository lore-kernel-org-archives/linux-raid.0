From: "Martin Bene" <martin.bene@icomedias.com>
Subject: AW: Am I dead?
Date: Mon, 2 Dec 2002 14:53:44 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4D618F6493CE064A844A5D496733D667031549@freedom.icomedias.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: Jakob Oestergaard <jakob@unthought.net>, Nick Lindsell <nick@nexnix.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Jakob / Nick

> > Am I dead or can I "freshen" sda2 so I can at least have 2 
> > devices in my  array and therefore
> > have a chance of either backing off the data or rebulding 
> > with a new sdc ?
> 
> http://unthought.net/Software-RAID.HOWTO/Software-RAID.HOWTO.html
> 
> Section 6.1 "Recovery from Multiple Disk Failure"

I think a pointer to neils mdadm should be included in the howto: Neils tool
allows much easier recovery from this situation, as it'll just override the
event counter and reuse all the other information. This means that you can't
mess up because of incorrect raidtab etc.

As Neil wrote recently: 

mdadm -A /dev/md0 --force /dev/sda1 /dev/sdb1 /dev/sdc2

will only 'force' into the array enough drives to make it work.  For
a 3 drive raid5 array, it ony needs to force in 2 drives, so it
takes the two most recent drives and uses them.  They will have all
the data on them, but no redundancy.

I suggest that after assembling the array, you 'fsck' the filesystem
on md0 just to make sure that the data is fine and then simply hot-add
the third device:
  mdadm /dev/md0 -a /dev/sdc

If fsck reports lots of error..... maybe try force the assmbly from a
different pair of drives. e.g.
   mdadm -A --force /dev/sda1 /dev/sdc2

and then do the fsck.

When doing these fscks to see if recovery worked, make sure you only check
but don't write/change anything to the disks. (e2fsck -n for example). 

