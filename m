From: Mike Hardy <mhardy@h3c.com>
Subject: Re: Slow reconstruction
Date: Wed, 29 Jun 2005 09:40:16 -0700
Message-ID: <42C2CEF0.7030108@h3c.com>
References: <1120061430.21458.236.camel@volt>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1120061430.21458.236.camel@volt>
Sender: linux-raid-owner@vger.kernel.org
To: John Rowe <rowe@excc.ex.ac.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


John Rowe wrote:
> First, thanks to all the authors of software RAID, which works really
> well. 
> 
> I have just one problem(!) and as disks get bigger it gets worse:
> reconstruction takes a long time. At the moment I've just had a disk
> fail on a 5x250 GB RAID5 array and it's going to take eight days to
> recover. Is there anything I can do to speed things up?
> 
> FWIW, each disk is the master drive on an IDE card, two of the disks are
> shared with the RAID1 root partition and one of the 5 devices is a RAID0
> stripe. The system isn't doing anything else, it's just used for backup.

That is an astonishingly slow reconstruction time.

Have you looked at hdparm informational output on each of the drives?
dmesg, grepping for the hard drive initialization information?

With speeds like that, I suspect you don't have DMA enabled for some
reason. Maybe someone else has seen something more exactly matching
this, but when speeds are this off, that's what its been for me in the past.

Running hdparm -Tt /dev/hdXX can tell you what the disks can do
individually, I'd start there, and look at the hdparm -i (or -I?) output
to see what they were set at, and start tuning the interface.

Hopefully that turns something up quickly.

-Mike
