From: maarten <maarten@ultratux.net>
Subject: Re: Spares and partitioning huge disks
Date: Sun, 9 Jan 2005 00:01:31 +0100
Message-ID: <200501090001.31738.maarten@ultratux.net>
References: <200501081855.j08It8910389@www.watkins-home.com> <200501082025.20463.maarten@ultratux.net> <crpg32$2rr$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <crpg32$2rr$1@sea.gmane.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday 08 January 2005 21:33, Mario Holbe wrote:
> maarten <maarten@ultratux.net> wrote:
> > On Saturday 08 January 2005 19:55, you wrote:
> >> My disks claim to be able to re-locate bad blocks on read error.  But I
> >> am not sure if this is correctable errors or not.  If not correctable
> >> errors are re-located, what data does the drive return?  Since I don't
> >> know, I
>
> ...
>
> > Afaik, if a drive senses it gets more 'difficult' than usual to read a
> > sector, it will automatically copy it to a spare sector and reassign it.
> > However, I
>
> No, this is usually not the case. At least I don't know IDE drives
> that do so. This is why I call it `sector read error'.

Do you mean SCSI ones do ?  If so, I thought the firmware intelligence between 
ATA and SCSI vanished long ago.

> Each newer disk has some amount of `spare sectors' which can be
> used to relocate bad sectors. Usually, you have two situations
> where you can detect a bad sector:
> 1. If you write to it and this attempt fails and
> 2. If you read from it and this attempt fails.

Hm.  I'm not extremely well versed on modern drive technology but 
nevertheless: How I understood it is somewhat different, namely:

1.  If you write to it and that fails the drive will allocate a spare sector.  
From that we [should be] able to conclude that if you get a write failure 
that the drive ran out of spare sectors. (is that a fact, or not??)

2. If you read from it, the drives' firmware will see an error and:
2a: Retry the read a couple more times, succeed, copy that to a spare sector 
and reallocate.   - OR
2b: Retry the read, fail miserably despite that and (only then) signal a read 
error to the host.

I've heard for a long time that drives are much more sophisticated than 
before, retrying failed reads.  They can try to read 'off-track' (off-axis) 
and such things that were impossible when stepping motors were still used. 
But that was more than 10 years ago, now they all have coil-actuated heads.

In other words, drives don't wait till the sector is really unreadable, 
they'll reallocate at the first sign of trouble (decaying signal strength, 
spurious crc errors, stuff like that).  This is also suggested by the 
observable behaviour of drive and OS; if a reallocation only would occur 
after the fact, ie. when the data is beyond salvaging, then every sector 
reallocation would by definition lead to corrupt data in that file. Generally 
speaking -since there are so many spare sectors- an OS would die very soon as 
all its files / libs/ DLLs got corrupted due to the reallocation (which is 
supposed to be transparent to the host, only the drive knows).
But... I have no solid proof of this though, other than reasoning like this.

> 1. would require some verify-operation, so I'm not sure if this
> is done at all in the wild.
> 2. has a simple problem: If you get a read-request for sector x
> and you cannot read it, what data should you return then? The
> answer is simple: you don't return data but an error (the read-
> error). Additionally you mark the sector as bad and relocate the
> next write-request for that sector to some spare sector and further
> read-requests then too. However, you still have to respond error
> messages for each subsequent read-request before the first
> relocated write-request appears.
> And afaik this is what current disks do. That's why you can just
> re-sync the failed disk to the array again without any problem -
> because the write-request happens then, the relocation takes place
> and everything's fine.

So basically what you're saying is that reallocation _only_ happens on 
_writes_ ?  Hm.  Maybe, I don't know...

The problem with my theory is that if it is true, then that automatically 
means that whenever md gets a read error that that data is indeed gone.
Or maybe that isn't a problem since the disk gets kicked, and afterwards 
during resync the reallocation pays off. Yeah.  That must be it. :-)

Maarten

