From: <jmolina@tgen.org>
Subject: Failed RAID5 array grow after reboot interruption; mdadm: Failed to restore critical section for reshape, sorry.
Date: Mon, 16 Jun 2008 01:23:59 -0700
Message-ID: <3E998AD6CC01E746957550D4CD642A742303F8@TGEN-M2.ad.tgen.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello!

Well, I came to report and ask for assistance with a failed RAID5 array grow.  I'm having a really crappy weekend -- my goldfish died and my RAID array crapped out.

Fortunately, I did a backup before I attempted this, but I am currently working to try and fix the problem rather than restore.

Yes I googled around before asking, and I've not yet found anything similar enough to my situation to be of help.

There does not appear to be anything wrong with the hardware of any disk.  Kernel version was 2.6.23.11 -- I am aware of some nasty bug in -rc3, but I don't think this is the same issue.  mdadm is v2.6.3.

I had three SATA disks and added two for a total of five, each 500GB in size.  My setup involves three partitions on each disk.  So, originally I was working with six partitions (three disks, three parts), then added two disks, for a total of five parts per RAID array, three RAID5 arrays, for grand total of fifteen parts.

I then stack LVM and ext3 on top of the three RAID5 arrays, but LVM and the file system is not a problem here or relevant, so let's ignore that.

During the grow process, this system slowly went unresponsive, and I was forced to reboot it after about 30 hours.  At first I was not able to run any mdadm commands to see the status of the grow (about 30 minutes after starting), then I was not able to log in with a new shell, then after about 24 hours I was able to use a previously opened shell to see that tons of CRON jobs and other work had backed up, however during all of this time the system was still acting as an IP router doing NAT.  Finally, after about 30 hours, the dhcpd daemon stopped giving out leases and then finally traffic stopped and I could not ping the host any longer (not a lease problem).

I should note that this is not a particularly highly loaded system.  It's basically a home office do-it-all router, file server, mail server, sort of thing.

After the reboot, one of the three RAID5 arrays (the one being grown) won't assemble.  My root is on this array, so I'm pretty much stuck in the initram shell, though I can mount the backup drive with all of my other binaries and files (came in useful since fdisk isn't on the initramfs).

I get the following, which I have typed out since I can't copy from the console;

(initramfs) mdadm --assemble /dev/md2
md: md2 stopped.
mdadm: Failed to restore critical section for reshape, sorry.

And that's it.  --force and --run do not help.



Doing an mdadmin --examine on the partitions shows that the Reshape Position was something like 520GB into the newly 680GB array, so it was definitely on it's way before it slowly went to hell.

I was under the impression that a reboot would simply cause the reshape to continue once the system came back up, but apparently not.  Something has farked it up badly.

Advice?  I'll give just about anything a try, but I'll have to start creating new partitions, arrays, and the whole bit tomorrow and restore the data.

