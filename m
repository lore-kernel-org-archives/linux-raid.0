From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: how to turn down cpu usage of raid ?
Date: Mon, 2 Feb 2004 20:37:42 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0402022000380.5536-100000@coffee.psychology.mcmaster.ca>
References: <021c01c3e9e2$d80b3640$0100a8c0@KARI>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <021c01c3e9e2$d80b3640$0100a8c0@KARI>
To: Matthew Simpson <matthew@symatec-computer.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Help!  I am having complaints from users about CPU spikes when writing to my
> RAID 1 array.

I can think of two answers: first, are you sure your drives are configured
sanely?  that is, using dma?  with any reasonable kernel, they should be,
but its possible to compile in the wrong driver or make some other mistake.
hdparm -iv /dev/hda and hdc should show using_dma=1.  you can also look
at /proc/ide/hda/settings.

second, perhaps you should simply make the kernel less lazy at starting
writes.  here's some basic settings from 2.4:

[hahn@hahn hahn]$ cat /proc/sys/vm/bdflush 
30      500     0       0       500     3000    60      20      0

 Value      Meaning                                                            
 nfract     Percentage of buffer cache dirty to activate bdflush              
 ndirty     Maximum number of dirty blocks to  write out per wake-cycle        
 dummy      Unused                                                             
 dummy      Unused                                                             
 interval   jiffies delay between kupdate flushes
 age_buffer Time for normal buffer to age before we flush it                   
 nfract_sync Percentage of buffer cache dirty to activate bdflush
 synchronously
 nfract_stop_bdflush Percetange of buffer cache dirty to stop bdflush
 dummy      Unused                                                


in theory, this means:
	- wake up bdflush when 30% of buffers are dirty.
	- write up to 500 blocks per wakeup.
	- 5 seconds between wakeups.
	- let a buffer age for 30 seconds before flushing it.
	- if 60% of buffers are dirty, start throttling dirtiers.
	- stop bdflush when < 20% of buffers are dirty.

of course, the code doesn't exactly do this, and 2.6 is very different.
still, I'm guessing that:
	- 500 buffers (pages, right?) is too little
	- 5 seconds is to infrequent
	- 30 seconds is probably too long

I have the fileserver for one of my clusters running much smoother with
ndirty=1000, interval=200 and age_buffer=1000.  my logic is that the disk
system can sustain around 200 MB/s, so flushing 4MB per wakeup is pretty 
minimal.  I also hate to see the typical burstiness of bdflush - no IO
between bursts at 5 second intervals.  I'd rather see a smoother stream of 
write-outs - perhaps even a 1-second interval.  finally, Unix's traditional
30-second laziness is mainly done in the hopes that a temporary file will be 
deleted before ever hitting the disk (and/or writes will be combined).  I 
think 30 seconds is an eternity nowadays, and 10 seconds is more reasonable.

in short:
echo '30 1000 0 0 200 1000 60 20 0' > /proc/sys/vm/bdflush

perhaps:
echo '30 1000 0 0 100 1000 60 20 0' > /proc/sys/vm/bdflush

for extra credit, investigate whether nfract=30 is too high (I think so, on
today's big-memory systems).  whether higher ndirty improves balance (these
writes would compete with application IO, so might hurt, albeit less with 
2.6's smarter IO scheduler.)  whether the sync/stop parameters make a
difference, too - throttling dirtiers should probably kick in earlier,
but if you lower nfract, also lower nfract_stop_bdflush...

> Is there a way I can tune software RAID so that writing
> updates doesn't interfere with other applications? 

remember also that many servers don't need atime updates; this can make a big 
difference in some cases.

