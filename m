From: AndyLiebman@aol.com
Subject: Performance Tuning Challenge
Date: Fri, 30 Jan 2004 09:27:28 EST
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <db.2466cce.2d4bc3d0@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Can anyone give me some advice on a tuning issue that surely must involve 
RAID settings? 

I am using a Linux system (P4 3.06 Ghz, 1 GB RAM, Mandrake 9.2, mandrake 
enterprise kernel 2.4.22-21 ) as a file server for 6-to-8 Windows XP video editing 
systems. All shared video and audio files are stored on two RAID5 arrays each 
built from 5 external firewire drives (connected to 5 true channels of 
firewire controllers). I am getting excellent read/write performance from the 
arrays. However, I'm trying to maximize performance of the system and I realize that 
requires balancing a number of tunable settings that all must interact with 
each other (virtual memory, RAID, tcp/ip, samba, xfs filesystem etc.). 

Please keep in mind that I have a limited number of users who are mostly 
trying to access portions of very large video and audio files. For instance, if 
the average user is looking at a string of video and audio clips that are around 
5 seconds each, each editing machine is asking for 17 MBs of continuous video 
and 1 MB of continuous audio for clip 1, and then the same for each 
subsequent clip. If the video were edited with "quick cuts" of 1 sec duration each, 
that would be 3.5 MBs of continuous video data and 150K of audio data for each 
clip. Keep in mind that the data can be spread out all over the RAID arrays -- 
so the disk heads have to move around constantly to get the data that each user 
needs (Of course, sometimes users are just watching long continuous video 
clips that are many minutes long -- which is less demanding on the system). 

My challenge is to tune the system so that the video and audio files required 
by each user arrive at each users machine when needed and so that no frames 
are skipped. When 6 editing machines (that's all I own) are operating 
simultaneously, video and audio plays great at normal speed on all machines. When some 
machines try to play video at 2x or 3x speed (which doubles or triples the 
speed at which data must be read from the RAID arrays), some skipping occurs. I 
have found, however, that by tweaking my virtual memory settings to 128 
min-readahead and 512 max-readahead (up from the Mandrake defaults of 3 and 31) that 
I can allow several machines to play video at 2x or 3x speed while the others 
play at normal speed and nobody gets any skipping. I also had to play around 
with the bdflush settings to get peak performance when writing video data to 
the arrays. 

I have no idea whether the virtual memory readahead settings that I have made 
make sense, and whether they are interacting in an ideal manner with the RAID 
and filesystem settings. 

It seems that it's possible to specify the amount of readahead for the RAID 
arrays. Regarding this, my questions are: 

-- Is it possible to set the RAID readahead after creating the arrays? And if 
so, how? When I run "cat /proc/mdstat" I see that read_ahead is set to 1024 
sectors. Can I -- and should I -- change that? In the kernel "info logs" I see 
that each time my arrays start up the "max total readahead window" is "set to 
2048k" and although the arrays are made up of 5 disks the log says "4 
data-disks, max readahead per data-disk: 512k". 

-- Can anybody tell me, given the kind of video and audio data my client 
machines are requesting, how to go about balancing the following variables? There 
must be a logic to setting these things so that they all work in harmony: 

-- xfs filesystem. Block size is currently set to 4096 the maximum allowed in 
Linux. That can't be changed now without losing exiting data. 
-- RAID stripe size = 128 currently. That can't be changed now without losing 
existing data
-- RAID readahead... Can that be changed?
-- virtual memory readahead
-- TCP/IP buffers... rmem_default, rmem_max, wmem_defaul, wmem_max (currently 
set to 327675 and 655350 respectively) and net.ipv4.tcp_wmem, 
ntet.ipv4.tcp_rmem 
-- Samba SO_RCVBUF SO_SNDBUF (currently set to 524280 each)
-- Samba read size and max smit (also set to 524280)
-- Intel Gigabit Ethernet card settings:  RxDescriptors (currently 1024) 
TxDescriptors (currently 4096)
-- anything else that interacts with all this. 

Also, does anybody know how to check to see if the 8MB Cache that each of my 
firewire drives has is being used for Read and Write Caching? Surely the use 
of this cache memory can greatly affect performance. 

This is like a wonderful puzzle. Changes do seem to make a big difference. 
All ideas would be appreciated. Please keep in mind that I'm not a Linux expert. 
I'm just a TV producer who knows a bit too much for his own good! So, please 
keep your replies as "untechnical" as possible. Thanks.

Andy Liebman
Resolute Films
