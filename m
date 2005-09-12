From: Andy Dawson <A.J.Dawson@Bradford.ac.uk>
Subject: Software RAID1 problems
Date: Mon, 12 Sep 2005 15:30:52 +0100 (GMT Standard Time)
Message-ID: <Pine.WNT.4.63.0509121523570.2828@endertoo>
References: <17189.12673.432061.932394@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17189.12673.432061.932394@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've had some problems recently with a RAID1 setup on a couple of Seagate 
SCSI disks.  I've setup the following partition scheme:

/dev/md0 swap (/dev/sda1 and /dev/sdb1)
/dev/md1 /    (/dev/sda2 and /dev/sdb2)

md1 functions fine, and has so far not given me any problems at all.  Md0 
however keeps dropping /dev/sdb1 from the array.  As I've set the system up 
to let me know via e-mail should anything occur, I do receive notification 
when sdb1 is kicked from the array.

Hot adding sdb1 back into the array works fine, until the next 
'degradedarray event'.

I've tested the disks with the Seagate tools (no problems), badblocks in 
read-only mode and in write mode as well (recreating md0 afterwards), all 
with no problems reported.

Has anyone any idea what might be causing the degradedarray event to 
occur?

Andy

Dr. Andy Dawson
A.J.Dawson@Bradford.ac.uk
http://www.mossie.org
http://www.museum-explorer.org.uk

  Never attribute to malice that which can adequately be explained by stupidity
