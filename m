From: Martijn <mailinglist@mindconnect.nl>
Subject: RAID1 performance and "task X blocked for more than 120 seconds"
Date: Sun, 18 Nov 2012 19:39:14 +0100
Message-ID: <50A92B52.7030905@mindconnect.nl>
Reply-To: mailinglist@mindconnect.nl
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good day,

I have a machine here that suffers from poor performance that I'm not 
able to explain, even with previous tips from this list.

Some details:
- Ubuntu Linux 10.04 LTS install
- mdadm 2.6.7.1-1ubuntu15

- RAID is a RAID1 array with 3 disks: 2 active, 1 spare
- a partitionable device is used: /dev/md127

- Mount lists the following partitions:
/dev/md127p2 on / type ext3 (rw)
/dev/md127p6 on /tmp type ext3 (rw,noexec,noatime)
/dev/md127p1 on /boot type ext2 (rw)
/dev/md127p3 on /home type ext3 (rw,noatime,usrquota)
/dev/md127p5 on /var type ext3 (rw,noatime)

- All 3 disks are connected over SATA 150 to a K8S Pro S2882 motherboard 
(http://www.tyan.com/archive/products/html/thunderk8spro_spec.html)
- Disks are all Seagate Barracuda 7200.12 ST31000528AS, 1TB.
- Smart finds the disks all in good condition

These tips from earlier performance questions where checked and applied 
already:
- The RAID member disks, /dev/sda and /dev/sdb, both have their 
scheduler set to deadline.
- NCQ is disabled by setting queue_depth to 1.
- The system has run without problems for almost 250 days. During this 
time, no large copy-actions where done. Installation and other processes 
where completed without trouble or any sign of performance problems.

The problem:
I was copying 3 GB of data using rsync, from another server to this 
machine over a 100 mbit connection. After some time it appeared to me as 
if one of the two systems was having trouble keeping up. Copying speed 
was a few MB/s and the transfer sometimes stopped for a longer period of 
time, then to continue again.

Looking at the receiving system, I noticed this in syslog:
task kjournald blocked for more than 120 seconds
task dkpg-preconfigure blocked for more than 120 seconds
[...]

dpkg-preconfigure being a process running at that time.

Eventually, the copy completed. But some time after the copy was 
completed, I still noticed a high (50-80%) %iowait and 2000 to 4000 
blocks being written to sda and sdb. I monitored this using iostat.

I waited for the system to return to 0 writes and a load of near 0 when 
I attempted to copy the data on disk from directory A to B, and the same 
problem occured.

This is a pretty normal Ubuntu 10.04 installation on a machine that I've 
used with mdadm RAID1 before with much older disks, performing without 
any problem.

Basically:
Any tips on how to trace this and how to fix it?

Thanks in advance,
- Martijn
