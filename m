From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Software RAID 0+1 with mdadm.
Date: Thu, 27 Jan 2005 00:02:03 -0500
Message-ID: <200501270500.j0R507908854@www.watkins-home.com>
References: <1106771556.21977.1.camel@serpent>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1106771556.21977.1.camel@serpent>
Sender: linux-raid-owner@vger.kernel.org
To: 'Brad Dameron' <brad@seatab.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sorry, I did not intend this to be the solution to your problem.  Just a
much more stable method for creating the 1+0 array.  With this method,
losing 1 disk only requires re-syncing 1 disk.  With the array as a 0+1, if
you lose 1 disk, you lose the whole RAID0 array, which then requires
re-syncing 2 disks of data.

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Brad Dameron
Sent: Wednesday, January 26, 2005 3:33 PM
To: linux-raid@vger.kernel.org
Subject: RE: Software RAID 0+1 with mdadm.

On Tue, 2005-01-25 at 15:04, Guy wrote:
> For a more stable array, build a RAID0 out of 2 RAID1 arrays.
> 
> Like this:
> 
> mdadm --create /dev/md1 --level=1 --chunk=4 --raid-devices=2 /dev/sdb1
> /dev/sdc1
> mdadm --create /dev/md2 --level=1 --chunk=4 --raid-devices=2 /dev/sdd1
> /dev/sde1
> mdadm --create /dev/md0 --level=0 --chunk=4 --raid-devices=2 /dev/md1
> /dev/md2
> 
> You can put a file system directly on /dev/md0
> 
> Are all of the disks on the same cable?
> 
> Not sure about your booting issue.
> 
> Guy
> 


Ya I did this setup as well. Still the same booting issue. Once it's
booted I can run mdadm --assemble --scan and it will find just the
stripe and then add it. I saw several people having this issue on a
google search. But never any solutions.

Brad Dameron
SeaTab Software
www.seatab.com



-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

