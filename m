From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Software RAID-1: step-by-step help needed...
Date: Tue, 10 Aug 2004 16:11:08 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0408101555400.1665@lion.drogon.net>
References: <41188A95.5000608@provincia.verbania.it>
 <Pine.LNX.4.56.0408100948230.1665@lion.drogon.net> <411892D0.8050701@provincia.verbania.it>
 <Pine.LNX.4.56.0408101021030.1665@lion.drogon.net> <4118AD33.8000803@provincia.verbania.it>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4118AD33.8000803@provincia.verbania.it>
To: Boniforti Flavio <boniforti@provincia.verbania.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 10 Aug 2004, Boniforti Flavio wrote:

> > OK - this is a very intersting and highly debatable subject!
>
> [cut]
>
> Well, I didn't mention at all what my server will have to do: it's
> simply a squid-proxy and will have apache installed (with PHP and
> mySQL), but just for small "intranet" applications (more "testing" like)...
> This is why I was about to apply following partition scheme:
>
> /dev/sda1 - 20 GB (Primary, ext3)
> /dev/sda2 -  1 GB (Primary, SWAP)
> /dev/sda5 - 52 GB (Logical, ext3)
>
> I will install / onto sda1 and /var onto sda5, what do you think?

I think you are probably going to waste a lot of space under /. 4GB will
be more than enough for / and /usr. 6GB if you are really paranoid. This
assumes that all the squid & apache logs go under /var, as well as the
squid cache and MySql databases. (I don't use the supplied Debian version,
I always compile from source, so you'll have to check here)

> >>I already installed it (as a test) following the instructions found at:
> >>http://www.inittab.de/manuals/debootstrap.html
> >
> > Er - thats a rather "intersting" way to install Debian - I use the
> > standard Woody CD set..
>
> Yes, but I have to install it that way, because the original Woody discs
>   don't contain a working driver for my SCSI Controller. :(

Thats getting to be more of a problem with Woody these days - I think
their supplied 2.4 kernel is 2.4.18... I've had intersting times with
promise IDE controllers and various on-board Ethernet controllers...

> >>I guess the hardest task will be configuring RAID, as the system works
> >>with the above procedure...
> >
> > OK. So with Debian, I basic, but minimal system on the first drive, not
> > touching the 2nd drive at all during this process... I'll usually compile
> > up a custome kernel at this point to make sure the IDE controllers have
> > DMA, if nothing else.
>
> I will install the system with the above mentioned "alien" procedure,
> then I would like to *first* activate RAID-1 (maybe it could need to
> recompile?) and then boot off RAID and see that everything works...
>
> > Then with the 2nd drive, partition it to be identical to the first disk,
> > then follow through the runes on the HowTo for mirroring the disks.
>
> I already partitioned both disks the same way (booting with System
> Rescue CD and using cfdisk).

OK.

> I don't actually understand what you are doing hereby... I mean: doesn't
> it suffice to start RAID and it handles the "mirroring" and all the
> stuff? Just following the HOW TO wouldn't be enough?

My method came from the HowTo... However, I've not re-read it for some
time... My way is Method 1 in the How-To, You might want to look at Method
2 in the How To. You might run out of disk space using my method trying to
copy / (which contains /usr) to a 1GB swap partition. You ought to be OK
with /var though - unless you've already loaded it up with stuff.

> > One other tip if you are using ext3 is to tune2fs -i0 -c0 /dev/hdaX after
> > the mkfs -t ext3 ... to make sure it's not force checked after so many
> > days/mounts.
>
> That's another "black hole" in my knowledge: what is this thing above?!?

When you create an ext2 (or ext3) filesystem, the system keeps track of
how many times it's been mounted and how many days have passed since it's
had an fsck run on it. If more than N days or more than M mounts, then it
will force an fsck at boot time... With ext3, in-theory the filesystem
will be in-sync all the time, so there should never be a need. The tune2fs
command alters the settings of number of days and mounts for that
particular filesystem.

Gordon
