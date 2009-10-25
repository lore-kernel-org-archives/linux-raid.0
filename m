From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: Is My Data DESTROYED?!
Date: Sun, 25 Oct 2009 10:49:30 -0600
Message-ID: <200910251049.30995.tfjellstrom@shaw.ca>
References: <903282.80364.qm@web38803.mail.mud.yahoo.com>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <903282.80364.qm@web38803.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: adfas asd <chimera_god@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun October 25 2009, adfas asd wrote:
> --- On Sat, 10/24/09, Christopher Chen <muffaleta@gmail.com> wrote:
> > Part of this sounds like you're looking for best practices.
> > I imagine
> > that's why you made a raid 10, and why you're using JFS.
> > It's probably
> > why you've been fiddling around with blockdev --setra and
> > all that
> > too
> 
> Exactly.
> 
> > The issue is, you're shooting in the dark unless you really
> > understand
> > what you want to do and why. You also said HTPC. Is this
> > basically a
> > large bucket for videos and other media?
> 
> Yes it's my video collection which I've worked long and hard to gather. 
>  Your point is taken that it doesn't have to be hot online, but if it can
>  why not?  I hate tape, and claim that it's obsolete.
> 
> I am shocked at all who think that human error is so prevalent, and in fact
>  obviates the case for RAID as backup.  I've run Debian for 12 years on all
>  my personal servers and remember literally only 3 or 4 cases in that time
>  where I muggered something up and had to go to backup.  There must be alot
>  of fsckups out there...
> 
> That said, I am now considering making the storage server in the garage a
>  backup rather than a RAID.  This means I'll want it to go to sleep most of
>  the time, and I'll need a mobo that does wake-on-LAN successfully and
>  automatically.
> 
> Now a backup by cron is nice and all, but what if it silently fails in some
>  obscure way?  This is one thing I like about RAID or ZFS, it lets you know
>  when anything's wrong.  I can imagine setting up a fancy-pants backup
>  system then going about my life, and some quirk happens on the next update
>  which subtlely hoses my exotic backup system.  It is desirable to have
>  bolt-tight assurance of backed-up data.  (And please don't bore us with
>  'nothing is for sure')

All I can say is I've been using RAID5 for a while now, and it surely isn't 
any kind of backup solution. When I first started using it I figured it would 
be "good enough" and it really REALLY isn't. A couple of times the array got 
corrupted beyond repair, and another couple times PEBKAC errors hit the array 
causing a total loss (each time loosing some important data, and 500G-1.5T of 
video)

Soon I intend to start up a "backup array" on a separate machine using raid6 
or raid0+1, or even just LVM (I'm not sure I like how raid10 isn't re-
sizable). Then I'll have my other arrays backed up to the backup array. And 
then I'll backup the important (non video stuff) to DVDR and a remote webhost 
(I really wish my upload was faster, currently uploading one of my backups 
will take on the order of a day or so to upload).

Long story short, RAID != Backup. It provides redundancy in case one (or more) 
disks fail, it does not protect from PEBKAC errors (like assembling the array 
wrong, or rm -fr /array), nor random bit flips caused by supposed cosmic rays, 
and other factors (failing ram?). RAID5 will happily save whatever is in ram 
at any given point and then XOR that, even if its wrong.

> Seems like a sync process, and then a checksum process to compare drives
>  and email a result, although minor files are changing all the time and I
>  wouldn't want to be notified if /tmp has changed.
> 
> Also I've noticed rsync mentioned several times.  This seems to have
>  facilities for incremental backups, but I've also read that it is
>  non-secure over networks and that we should use scp instead.  But scp
>  doesn't seem to have incremental attributes.  Yes, this is my home LAN,
>  but I have a thing about security in and out.  Isn't there another way of
>  syncing two disks (over a network)?
> 

rsync supports the use of ssh, so it should be fine. I use rsync+ssh to backup 
all of the important documents and settings off of all of my machines. runs a 
couple times a day using rsnapshot.

> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
