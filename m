From: Steven Ihde <x-linux-raid@hamachi.dyndns.org>
Subject: Re: Looking for the cause of poor I/O performance
Date: Sat, 4 Dec 2004 17:00:08 -0800
Message-ID: <20041205010008.GA8091@hamachi.dyndns.org>
References: <200412041759.iB4HxG922078@www.watkins-home.com> <Pine.LNX.4.44.0412041809530.21262-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0412041809530.21262-100000@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: Guy <bugzilla@watkins-home.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Well while we're on the subject ;-)

I have a three-disk raid5 array.  In summary, the raid5 performs
slightly worse than any of the three disks alone.  Memory bandwidth
tested by hdparm seems more than adequate (1.6GB/sec).  Shouldn't
read-balancing give me some benefit here?  Kernel is 2.6.8.

The system is an i865PE (I think) chipset with a 2.4GHz P4.  I believe
the memory bandwidth is more than adequate and that the disks are
performing up to spec when tested alone (Seagate Barracudas, hda & hdc
are 80GB PATA, sda is 120GB SATA):

/dev/hda:
 Timing cached reads:   3356 MB in  2.00 seconds = 1676.58 MB/sec
 Timing buffered disk reads:  122 MB in  3.03 seconds =  40.24 MB/sec
/dev/hdc:
 Timing cached reads:   3316 MB in  2.00 seconds = 1657.42 MB/sec
 Timing buffered disk reads:  122 MB in  3.02 seconds =  40.34 MB/sec
/dev/sda:
 Timing cached reads:   3344 MB in  2.00 seconds = 1673.09 MB/sec
 Timing buffered disk reads:  122 MB in  3.04 seconds =  40.19 MB/sec

Now, the raid5 array:

/dev/md1:
 Timing cached reads:   3408 MB in  2.00 seconds = 1704.26 MB/sec
 Timing buffered disk reads:  114 MB in  3.01 seconds =  37.83 MB/sec

Slightly worse!  Bonnie++ gives me an even lower number, about 30.9
MB/sec for sequential input from the raid5.

hda and hdc are attached to the on-board PATA interfaces (one per
channel, no slaves on either channel).  sda is attached to the
on-board SATA interface (the other on-board SATA is empty).  

A possible clue is that when tested individually but in parallel, hda
and hdc both halve their bandwidth:

/dev/hda:
 Timing cached reads:   1552 MB in  2.00 seconds = 774.57 MB/sec
 Timing buffered disk reads:   68 MB in  3.07 seconds =  22.15 MB/sec
/dev/hdc:
 Timing cached reads:   784 MB in  2.00 seconds = 391.86 MB/sec
 Timing buffered disk reads:   68 MB in  3.02 seconds =  22.54 MB/sec
/dev/sda:
 Timing cached reads:   836 MB in  2.00 seconds = 417.65 MB/sec
 Timing buffered disk reads:  120 MB in  3.00 seconds =  39.94 MB/sec

Could there be contention for some shared resource in the on-board
PATA chipset between hda and hdc?  Would moving one of them to a
separate IDE controller on a PCI card help?

Am I unreasonable to think that I should be getting better than 37
MB/sec on raid5 read performance, given that each disk alone seems
capable of 40 MB/sec?

Thanks,

Steve

