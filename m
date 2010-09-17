From: Tim Small <tim@seoss.co.uk>
Subject: Deadlock in md barrier code? / RAID1 / LVM CoW snapshot + ext3 /
 Debian 5.0 - lenny 2.6.26 kernel
Date: Fri, 17 Sep 2010 15:53:55 +0100
Message-ID: <4C938103.1010304@seoss.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: mike@hartmanipulation.com
List-Id: linux-raid.ids

Hi,

I have a box with a relatively simple setup:

sda + sdb are 1TB SATA drives attached to an Intel ICH10.
Three partitions on each drive, three md raid1s built on top of these:

md0 /
md1 swap
md2 LVM PV


During resync about a week ago, processes seemed to deadlock on I/O, the 
machine was still alive but with a load of 100+.  A USB drive happened 
to be mounted, so I managed to save /var/log/kern.log  At the time of 
the problem, the monthly RAID check was in progress.  On reboot, a 
rebuild commenced, and the same deadlock seemed to occur between roughly 
2 minutes and 15 minutes after boot.

At this point, the server was running on a Dell PE R300 (12G RAM, 
quad-core), with an LSI SAS controller and 2x 500G SATA drives.  I 
shifted all the data onto a spare box (Dell PE R210, ICH10R, 1x1TB 
drive, 8G RAM, quad-core+HT), with only a single drive, so I created the 
md RAID1s with just a single drive in each.  The original box was put 
offline with the idea of me debugging it "soon".

This morning, I added in a second 1TB drive, and during the resync 
(approx 1 hour in), the deadlock up occurred again.  The resync had 
stopped, and any attempt to write to md2 would deadlock the process in 
question.  I think it was doing an rsnaphot backup to a USB drive at the 
time the initial problem occurred - this creates an LVM snapshot device 
on top of md2 for the duration of the backup for each filesystem backed 
up (there are two at the moment), and I suppose this results in lots of 
read-copy-update operations - the mounting of the snapshots shows up in 
the logs as the fs-mounts, and subsequent orphan_cleanups.  As the 
snapshot survives the reboot, I assume this is what triggers the 
subsequent lockup after the machine has rebooted.

I got a couple of 'echo w > /proc/sysrq-trigger' sets of output this 
time...  Edited copies of kern.log are attached - looks like it's 
barrier related.  I'd guess the combination of the LVM CoW snapshot, and 
the RAID resync are tickling this bug.


Any thoughts?  Maybe this is related to Debian bug #584881 - 
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=584881

... since the kernel is essentially the same.

I can do some debugging on this out-of-office-hours, or can probably 
resurrect the original hardware to debug that too.

Logs are here:

http://buttersideup.com/files/md-raid1-lockup-lvm-snapshot/

I think vger binned the first version of this email (with the logs 
attached) - so apologies if you've ended up with two copies of this email...

Tim.


-- 
South East Open Source Solutions Limited
Registered in England and Wales with company number 06134732.
Registered Office: 2 Powell Gardens, Redhill, Surrey, RH1 1TQ
VAT number: 900 6633 53  http://seoss.co.uk/ +44-(0)1273-808309



