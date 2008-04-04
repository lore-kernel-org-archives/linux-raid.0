From: Brett Dikeman <brett@cloud9.net>
Subject: segfault in mdadm v2.6.4
Date: Fri, 4 Apr 2008 01:03:48 -0400
Message-ID: <2C1F2D1D-8799-4E11-8CDB-1827769496F3@cloud9.net>
Reply-To: brett@cloud9.net
Mime-Version: 1.0 (Apple Message framework v919.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On a debian/testing system, under both 2.6.22 and 2.6.24, I've been  
trying to set up a 4-drive RAID6 array.  I see the following segfault  
listed in /var/log/messages, and it's appeared each time I've  
assembled the array.  Two drives are on the onboard SATA; two are on  
external USB-SATA bridges (this is not permanent- just what I had  
available for migrating off an other array.)

Also, the array's initial "resync" hung after a few hours, much to my  
great annoyance (it's a +10 hour process; I was 3 hours in.)  It took  
the entire device with it- I couldn't unmount the filesystem.  I  
eventually tracked it to one of the four drives, on the USB<->SATA  
bridge; it wasn't responding, and the other 3 drives seemed fine.   It  
then took the entire system with it a few minutes later; all the  
running daemons stopped responding and I couldn't get a shell.  After  
waiting half an hour for a device timeout, etc- I unplugged the hung  
drive since I didn't have anything on the array.  No change, no kernel  
messages logged before or after, not even when the USB device  
'disappeared.'  I gave up and power-cycled the box.

I'd appreciate being cc'd on followups- though I will be checking the  
archives.  I'm happy to provide additional info and run tests.

Thanks!
Brett

Apr  4 00:36:46 frank kernel: md: md1 stopped.
Apr  4 00:36:46 frank kernel: md: unbind<sdc2>
Apr  4 00:36:46 frank kernel: md: export_rdev(sdc2)
Apr  4 00:36:46 frank kernel: md: unbind<sdd2>
Apr  4 00:36:46 frank kernel: md: export_rdev(sdd2)
Apr  4 00:36:46 frank kernel: md: bind<sdd2>
Apr  4 00:36:46 frank kernel: md: bind<sde2>
Apr  4 00:36:46 frank kernel: md: bind<sdf2>
Apr  4 00:36:46 frank kernel: md: bind<sdc2>
Apr  4 00:36:46 frank kernel: xor: automatically using best  
checksumming function: generic_sse
Apr  4 00:36:46 frank kernel:    generic_sse:  3086.000 MB/sec
Apr  4 00:36:46 frank kernel: xor: using function: generic_sse  
(3086.000 MB/sec)
Apr  4 00:36:46 frank kernel: async_tx: api initialized (sync-only)
Apr  4 00:36:46 frank kernel: raid6: int64x1    693 MB/s
Apr  4 00:36:46 frank kernel: raid6: int64x2    922 MB/s
Apr  4 00:36:46 frank kernel: raid6: int64x4   1083 MB/s
Apr  4 00:36:46 frank kernel: raid6: int64x8    794 MB/s
Apr  4 00:36:46 frank kernel: raid6: sse2x1    1268 MB/s
Apr  4 00:36:46 frank kernel: raid6: sse2x2    1828 MB/s
Apr  4 00:36:46 frank kernel: raid6: sse2x4    1929 MB/s
Apr  4 00:36:46 frank kernel: raid6: using algorithm sse2x4 (1929 MB/s)
Apr  4 00:36:46 frank kernel: md: raid6 personality registered for  
level 6
Apr  4 00:36:46 frank kernel: md: raid5 personality registered for  
level 5
Apr  4 00:36:46 frank kernel: md: raid4 personality registered for  
level 4
Apr  4 00:36:46 frank kernel: raid5: device sdc2 operational as raid  
disk 0
Apr  4 00:36:46 frank kernel: raid5: device sdf2 operational as raid  
disk 3
Apr  4 00:36:46 frank kernel: raid5: device sde2 operational as raid  
disk 2
Apr  4 00:36:46 frank kernel: raid5: device sdd2 operational as raid  
disk 1
Apr  4 00:36:46 frank kernel: raid5: allocated 4274kB for md1
Apr  4 00:36:46 frank kernel: raid5: raid level 6 set md1 active with  
4 out of 4 devices, algorithm 2
Apr  4 00:36:46 frank kernel: RAID5 conf printout:
Apr  4 00:36:46 frank kernel:  --- rd:4 wd:4
Apr  4 00:36:46 frank kernel:  disk 0, o:1, dev:sdc2
Apr  4 00:36:46 frank kernel:  disk 1, o:1, dev:sdd2
Apr  4 00:36:46 frank kernel:  disk 2, o:1, dev:sde2
Apr  4 00:36:46 frank kernel:  disk 3, o:1, dev:sdf2
Apr  4 00:36:46 frank kernel: mdadm[3954]: segfault at 0 rip 412d2c  
rsp 7fffcdd18fa0 error 4

