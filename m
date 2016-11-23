From: Diego Guella <diego.guella@deviltechnologies.com>
Subject: raid1 bitmap and multiple removed disks
Date: Wed, 23 Nov 2016 09:50:08 +0100
Message-ID: <ce2ba842-22f0-eebf-856c-f07d38574489@deviltechnologies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

(2nd attempt: the previous one didn't make it)
Hi,

I am using linux raid1 for a double-purpose: redundancy and backup.

I have a raid1 array of 5 disks, 3 of which are kept for backup purposes.
Let's call disks A, B, C, D, E.
Disks A and B are _always_ connected to the system.
Disks C, D, E are backup disks.
Here follows a description of how I use the backup disks.
This morning I connect disk C, and let it resync.
Tomorrow morning, I shut down the system, remove disk C and keep it away 
as a daily backup.
I connect the next disk (D), then start up the system.
Linux raid1 recognizes the "old" disk and does not allow it to enter the 
array (this is evidenced by system logs).
I then add disk D to the array, and let it resync.
The next day, I connect the next disk (E), and so on, rotating them.
The "connect and disconnect" is always performed when the system is 
powered off, although sometimes I hot-connect the disk with the system 
already powered up.
The purpose of this is to have an emergency backup: I can disconnect ALL 
disks from the system and connect only one of the daily backups, going 
"back to the past"(TM).

This array has a write-intent bitmap, in order to speed up the resync 
(it is a 4TB array, and sometimes it needs nearly 20 hours to resync 
without bitmaps due to system load).

This worked flawlessly (for some years) until some days ago, when the 
array suffered a strange inconsistency, and the filesystem nearly gone 
nuts in about 20 minutes of uptime. I will elaborate more on this later.

Since that problem happened, some questions come to my mind:
What raid1 bitmaps allow me to do?
Can they record _correctly_ the state of multiple removed disks, in 
order to overwrite only out-of-sync chunks of multiple removed disks?
In other words, am I allowed to do what I described above?
If not, can I change something in my actions in order to have a daily 
backup using raid1?


System details:
# cat /etc/debian_version
6.0.10
# mdadm --version
mdadm - v3.1.4 - 31st August 2010


