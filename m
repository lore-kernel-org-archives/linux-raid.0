From: Bill Cronk <ngc4013@cox.net>
Subject: Question regarding mdadm and RAID boxes
Date: Sun, 31 Oct 2004 21:32:40 -0500
Message-ID: <4185A048.1070308@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@cse.unsw.edu.au
List-Id: linux-raid.ids

I recently have had the pleasure to start using mdadm. Previously I was 
using the old raidtools and creating a raidtab file to reflect the 
current configuration requirements for the attached RAID boxes. Since at 
work I have had to use Redhat only on my computers, I have been using 
RH-9 with the intention of migrating up to FC2 or FC3 when stable. So I 
started using FC2 and tried moving my RAID boxes over which gave me some 
problems, but after some discussions with co-workers and a question 
being answered on the fedora-list group, I decided to apply the hard 
drive flag 'fd' and then move over to using mdadm only to manage my RAID 
boxes.

So this is where the real problems started up which led to my resolving 
the issues, but with one underlying question which I will get to shortly.

The goal is to setup two preconfigured RAID boxes which both come from 
different servers and connect them through one Adaptec U320 controller 
card on a dual Athlon MP Tyan motherboard. The two RAID boxes each 
contain 14 U320 SCSI drives setup in a JBOD configuration with one box 
being raid0 and the other raid5. Only one of the two boxes has exisitng 
data on it and blowing it away was out of the question. The problem I 
ran into was thought to be related strictly to the udev, hotplug, and 
creation of the extra /dev/md1 needed for the second box. After a couple 
of week of multiple emails with people and chasing this in circles I 
decided to blow away the new RAID box setup of RAID5 and rebuild it 
while the primary RAID box is still attached. First problem I 
encountered was in rebuilding the RAID array with 'mdadm --create 
......' which didn't work. In short, I had to blow away the drive 
partitions, reboot, recreate the drive partitions then run the 'mdadm 
--create ...' to make it rebuild the array. Then when I ran disk druid 
to look at the drives I discovered what ended up being the root of all 
my problems. Before me was the listing for two RAID boxes and oh by the 
way both were labeled as /dev/md0. Now this is the whole source of the 
problems which I had already come upon through different means, but disk 
druid just proved my theory out.

So I rebuilt the array with the 'mdadm --create ...' command with the 
addiiton of specifying the /dev/md1 connection. This also required the 
manual creation of the /dev/md1 device file so the creation of the RAID 
device could take place. After creation and a reboot the udev actually 
discovered the second RAID with the superblock label for /dev/md1 and 
did it's thing to make everything work now. This is great!!

Now the question: Is there anything in mdadm allowing one to take a 
previously setup RAID box from another server and attach it to a second 
SCSI port and modify only the superblocks to change out the /dev/md0 to 
/dev/md1 or md2 or ....... so on?

This is very critical for managing the RAID boxes since if you already 
have one /dev/md0 connection you can not easily have a second device 
attached then connected to without errors or failure to setup the RAID 
box if it too is /dev/md0.

My solution to this at this point in time is to make these two RAID 
boxes be md4 and md5 while some of the other boxes become md0, md1, md2, 
md3, and so on. Of course I will need to blow away all the data and then 
rebuild the arrays from tapes.


Thanks for your time,

Bill Cronk
