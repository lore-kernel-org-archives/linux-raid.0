From: Louis-David Mitterrand <vindex@apartia.org>
Subject: Re: recovering after a /dev/sda failure on raid1
Date: Mon, 5 Aug 2002 11:26:41 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020805092641.GA577@apartia.org>
References: <20020801144922.GA5284@apartia.org> <15690.63749.164322.929689@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <15690.63749.164322.929689@notabene.cse.unsw.edu.au>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Aug 03, 2002 at 07:26:29AM +1000, Neil Brown wrote:
> On Thursday August 1, vindex@apartia.org wrote:
> > 
> > I have a root raid1 partition on /dev/sda1 & /dev/sdb1 (swap on
> > /dev/sda2 & /dev/sdb2). The server boots directly from the raid
> > partition. 
> > 
> > Now /dev/sda1 and /dev/sda2 have both failed and been removed from the
> > array and I am getting ready to replace the disk tonight.
> 
> Lucky you :-)

It went fast fortunately ;-) And yes, I am very lucky to have raid1
notify me by email through mdadm of a disk failure.

FWIW the disk that is malfunctioning is a 3-month-old Fujitsu 15k 36G
(MAM3367MP) which is an expensive server-grade disk. The reason I
selected Fujitsu was because of reported quality problems on IBM disks
and Fujitsu's good reputation on SCSI (their IDE line is bad however).
I am looking for informed opinions on these disks and recommendations
for future purchases. What are the most reliable SCSI disks out there?

It must be: fast, affordable, reliable, (select any two ;-)

> > 
> > What is the best way to proceed to minimize downtime?
> > 
> > My concern is that if I power down and replace /dev/sda the machine
> > won't be able to reboot without a rescue CD (lilo.conf has root=/dev/md0
> > and boot=/dev/md0) or will it? 
> > 
> > When the bios (Dell Poweredge 1500) will try /dev/sda's mbr and fail,
> > will it then automatically try /dev/sdb?
> 
> With most bioses I have seen you can explicitly tell it which device
> to boot from.  But cannot say for-sure about Dell Poweredge.

Yes, I found it's in the SCSI bios itself. Very configurable.

Unfortunately when I tried booting from /dev/sdb the screen filled with
010101010 instead of "lilo". And this is on debian unstable, having run
lilo on /dev/md0 just prior booting. In fact I found that having root
and boot set to /dev/md0 in lilo.conf does not allow me to boot my raid1
partition. However if I set root=/dev/sda all goes well. Any trick here?
(both disks are identical)

> > 
> > Or should I swap /dev/sdb on the scsi ribbon to have it take the first
> > place and thus become /dev/sda or will this just confuse the kernel
> > raid driver? (the letter on scsi drives is dependent on their place on
> > the ribbon cable, isn't it?)
> 
> It isn't the position on the ribbon cable.  It is the position in the
> scsi device number ordering.  If  you make sure the new drive has a
> larger number than the old drive, the old drive will appear as sda.

I'm really ashamed to have asked that one, memory lapse on my part.

> > 
> > Alternatively I was thinking of booting with a rescue CD (after
> > replacing /dev/sda) with the "root=/dev/md0", creating my partitions,
> > running lilo and rebooting into production for final reconstruction.
> > Would that be the safest bet?
> 
> This sounds like the best bet to me.  You do have to boot twice, but
> if you try the other, less well understood (by you atleast) approach,
> there is an even chance you will need to reboot a couple of times
> anyway.

Having failed to boot /dev/sdb this is what I ended up doing and all
went well.

Thanks for your help and ideas, cheers,

-- 
ldm@apartia.org 
