From: Russ Price <rjp_raid@fubegra.net>
Subject: Re: Hard drive Reliability?
Date: Thu, 20 May 2004 17:27:56 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40AD30EC.9070809@fubegra.net>
References: <200405200034.i4K0YpB17310@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200405200034.i4K0YpB17310@www.watkins-home.com>
To: 'LinuxRaid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Guy wrote:
> I have an old system with 2 18 Gig SCSI disks.  One IBM and one Seagate.
> Both run very hot!  I added extra cooling fans.  Both fans failed about 2
> years ago.  Only the CPU and power supply fans still work.   The disk drives
> are too hot to touch.  Much too hot to touch!  The system is running 99.99%
> of the time.  No disk problems.  The system is 4-5 years old as a guess.  To
> help date it, it is a P3-350Mhz.  My wife uses this computer.  :)

The lack of start-stop cycles may work in your favor; you don't have as 
many thermal expansion/contraction cycles or startup electrical surges 
to worry about.  Of course, if stiction strikes after a power-off, you 
could be in trouble...

In any case, it's not a bad idea to set up smartd and look after your 
system logs.  If your drives have temperature sensors, it's a good idea 
to tell smartd to report raw values for temperature (usually -r 194 -R 
194 in the smartd.conf file); the normalized values look wacky.

I also have hddtemp and the hddtemp plugin for gkrellm, so I can easily 
check the temperatures on my desktop, at least for my four-drive SATA 
RAID5 array.  My older 30GB Maxtors don't have temperature sensors, but 
they're in the same fan-cooled bays as the Samsung SATA drives, and they 
all run reasonably cool to the touch.  Current room temperature is about 
28 C, and the temperature display reports 29-33 C for the drives in the 
array.

	Russ
