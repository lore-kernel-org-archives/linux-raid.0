From: <robin-lists@robinbowes.com>
Subject: RE: mount-by-label finds drive not array ????
Date: Thu, 22 Jul 2004 19:46:26 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <S266910AbUGVSq2/20040722184628Z+2509@vger.kernel.org>
References: <20040722175424.GF26291@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040722175424.GF26291@percy.comedia.it>
To: 'Luca Berra' <bluca@comedia.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org 
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Luca Berra
> Sent: 22 July 2004 17:54
> To: linux-raid@vger.kernel.org
> Subject: Re: mount-by-label finds drive not array ????
> 
> On Thu, Jul 22, 2004 at 05:33:13PM +0100, 
> robin-lists@robinbowes.com wrote:
> >> 
> >> /dev/md0        /mnt/bar      ext3      defaults        0 4
> >> 
> >> Since if I do it by "LABEL=", it tries to mount hda1, not md0!
> >> 
> >> Is this just a known/accepted brain-deadness of the mount code?
> >
> >Tom,
> >
> >I'm just considering doing something like this.
> >
> >Did you ever get any resolution to this issue?
> is there any need to mount a md device by label, since you 
> can already identify the md components by uuid when you 
> assemble the raid.

Probably not. It's just something I'm trying.

Incidentally, it seems to work OK for me.

I'm using Fedora Core 2. Here's my /etc/fstab (only labelled partitions
listed):

LABEL=dude_root         /                       ext3    defaults        1 1
LABEL=hda_music         /home/slimserver/music  ext3    defaults        0 0
LABEL=/                 /mnt/hda                ext3    defaults        1 1
LABEL=/boot             /mnt/hda/boot           ext3    defaults        1 2
LABEL=/home             /mnt/hda/home           ext3    defaults        1 2
LABEL=/opt              /mnt/hda/opt            ext3    defaults        1 2
LABEL=/tmp              /mnt/hda/tmp            ext3    defaults        1 2
LABEL=/usr              /mnt/hda/usr            ext3    defaults        1 2
LABEL=/usr/local        /mnt/hda/usr/local      ext3    defaults        1 2
LABEL=/var              /mnt/hda/var            ext3    defaults        1 2

And here's what get's mounted:

/dev/md0 on / type ext3 (rw)
/dev/hda11 on /home/slimserver/music type ext3 (rw)
/dev/hda7 on /mnt/hda type ext3 (rw)
/dev/hda1 on /mnt/hda/boot type ext3 (rw)
/dev/hda3 on /mnt/hda/home type ext3 (rw)
/dev/hda5 on /mnt/hda/opt type ext3 (rw)
/dev/hda10 on /mnt/hda/tmp type ext3 (rw)
/dev/hda2 on /mnt/hda/usr type ext3 (rw)
/dev/hda6 on /mnt/hda/usr/local type ext3 (rw)
/dev/hda9 on /mnt/hda/var type ext3 (rw)

The reason I decided I'd like to use labels is because I found I was
spending far too much time trying to find file systems on old disks to copy
data across in a new system.

Take the example above: /dev/hda is from another system and I wanted to
mount all partitions to check some config settings. I found I was doing
stuff like:

# cat /proc/partitions
major minor  #blocks  name

   3     0  120060864 hda
   3     1     104391 hda1
   3     2    3068415 hda2
   3     3    2048287 hda3
   3     4          1 hda4
etc.

# mkdir /mnt/hda1 ; mount /dev/hda1 /mnt/hda1
# ls /mnt/hda1
(ah, /dev/hda1 must me the old /boot partition)
# umount /dev/hda1
etc.

Eventually I'd find the root filesystem, mount it, then mount all the other
filesystems on the old root fs.

With labels I can just do this:

# findfs LABEL=hostname_root
/dev/hda7

# mount /dev/hda7 /mnt/hda

Or even:

# mount `findfs LABEL=hostname_root` /mnt/hda

Or even;

# for d in usr usr/local tmp home var ; do mount `findfs LABEL=hostname_$d`
/dev/hda/$d ; done

R.

