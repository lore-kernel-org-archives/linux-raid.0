From: Trevor Cordes <trevor@tecnopolis.ca>
Subject: Poor RAID6 performance on frankenstein server
Date: Sat, 24 Dec 2005 20:32:30 -0600
Message-ID: <20051225023230.GA5047@pog.tecnopolis.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm not sure if this is a kernel-ide-disk issue or a raid issue, so I'm 
trying here first:

I've built a frankenstein file and mythtv server with RAID 6 8x250GB + 
2x300GB disks for 2TB usable space.  I used 4 generic PCI (Promise, 
2xSyba(SiI_IDE), C-Media) and onboard(Intel)+onboard(Promise) PATA 
controllers.  (The 2 bigger 300 disks also house my root/boot/swap RAID1 
partitions.)  I know, cheesy, but this is a SUPER cheap way to get GOBS of 
storage space... those IDE cards are cheap and most of my money goes to 
drives.

Works great... except for during heavy disk access my MythTV recordings
will get somewhat glitchy audio.  Stop the disk access and the audio
returns to normal.  Even with moderate disk access it's ok.  It's just
when it's heavy.  And the glitches are usually every few seconds unless
it's really heavy where the audio gets nearly unintelligible for 10 secs
or so.

The audio, and the video, come through USB2 from a Plextor hardware MPEG4
encoder.  The video +audio stream is not disk intensive, only about
600k/sec.  However, the way the Plextor works is the audio is
software-encoded into MP3 on the fly (ie: not in the Plextor like the
video).  My video almost never glitches -- it's just the audio.

If I run some simple tests I can make it glitch recording some TV while 
doing something like copying a duplicating a large TV file with cp.  The 
CPU load never gets above 34% and bounces between 25-35%.

I have done all the hdparm tweaks I can think of including: DMA (-d1), 
unmasqirq (-u1), lookahead, multiple io 16, 32bit transfers.  I tried 
using an SMP kernel (it's a UP system) for enhanced APIC.  All drives are 
running as master with NO slaves except for 1 (unused during the tests) 
optical drive.  I did used to have 2 drives as slaves and no unmasqirq and 
it was really bad, and things did improve when I moved to all-master and 
enabled unmasqirq.  It's like if I could tweak it just a little more I'd 
have it perfect.

The CPU is a not-slow Pentium 4 2.4/400 on Intel 845D chipset.  RAM is 1GB 
ECC.

Anything else I can try tuning to fix this nagging issue?  Any ideas on 
what's biting me here?

Thanks!  And Merry Christmas to all!
