From: AndyLiebman@aol.com
Subject: I'm Astounded by How Good Linux Software RAID IS!
Date: Sat, 22 Nov 2003 12:07:52 EST
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <139.28313621.2cf0f1e8@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I want to congratulate a lot of Linux Software Raid folks. Really. I just set 
up a RAID 5 array on my Linux Machine (P4-3.06 Ghz -- Mandrake 9.2) using 5 
External Firewire Drives. 

The performance is SO GOOD that I am able to write uncompressed 8-bit video 
files to my array through a Copper Gigabit network! That's a sustained 18 
MB/sec -- going for 20 minutes straight. 

Under Windows 2000 using Veritas Volume Manger's RAID 5, I was barely able to 
sustain 4 MB/sec writing to the exact same drives -- even when I was writing 
directly from the Win 2000 server and not going through my network (Reading, 
however, was around 20 MB/sec). With Linux, I'm getting about 20 MB/sec through 
my TCP/IP network! And the Linux box isn't even struggling. Wow. 

I AM surprised by one thing, though. This is the second firewire array that I 
have put on my Linux machine. 

The first one was set up with 6 Firewire Drives that are bigger (200 GB 
versus 120 GB) and that have larger onboard cache (8 MB versus 2 MB). I set up 
those 6 drives as a RAID 10 array -- 3 mirrored pairs with a RAID 0 stripe on top 
of that. The performance I was able to achieve with the RAID 10 array was 
actually NO BETTER than what I am getting with RAID 5. Does that make sense? 

Should I be getting better (or at least equal) performance with RAID 5 
compared to RAID 10? Shouldn't RAID 10 be faster both reading and writing? 

In both cases, I am using 128K chunk sizes, and the xfs filesystem with the 
maximum allowable Linux block size (4096) and an INTERNAL logfile. 

I would love to hear your comments. 

Andy Liebman
