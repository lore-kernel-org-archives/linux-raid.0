From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Partitioned raid and major number
Date: Mon, 1 Mar 2004 12:09:05 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16450.36145.988988.684449@notabene.cse.unsw.edu.au>
References: <20040225145624.GA1513@cistron.nl>
	<16445.12026.812778.621025@notabene.cse.unsw.edu.au>
	<20040226215144.GC11831@drinkel.cistron.nl>
	<16446.36226.591283.495194@notabene.cse.unsw.edu.au>
	<16446.39583.968782.41221@notabene.cse.unsw.edu.au>
	<20040227165614.GO23988@traveler.cistron.net>
	<16450.32963.829675.526061@notabene.cse.unsw.edu.au>
	<20040301004256.GI14194@drinkel.cistron.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Miquel van Smoorenburg on Monday March 1
To: Miquel van Smoorenburg <miquels@cistron.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday March 1, miquels@cistron.nl wrote:
> 
> What do you think of that approach ? Converting from a 1 disk setup
> to a 2-disk RAID1 setup on an existing system is something that lots
> of people want to do, seeing that the software raid howto even has
> a few paragraphs dedicated to it.

What I am thinking of doing is allowing:

   md=0,1,/dev/sda

to assemble a raid1 array without a superblock which uses just
/dev/sda.
Then

   md=d0,1,/dev/sda root=/dev/md_d0p1

would boot off md/d0p1 instead of sda1, but it would be the same data.

Then you would be able to add mirrors to this with something like:

  mdadm --grow /dev/md/d0 --disks=2
  mdadm /dev/md/d0 --add /dev/sdb

and you could convert it into an array with a persistent superblock
using:
   mdadm --grow /dev/md/d0 --persistent=yes

The only difficult bit is the setting a persistent superblock means
reducing the size of the device, and I would like it to be hard to do
that in error, but not impossible to do it.

> 
> Though it works, and I can boot from it, lilo doesn't understand it yet
> so I'll have to hack on that next.

I have lilo working well with partitioned raid in 2.4.
I have a stanza in /etc/lilo.conf like:

boot=/dev/Mda
disk=/dev/Mda
 bios=0x80
 sectors=63
 heads=255
 cylinders=1024
 partition=/dev/md/d0p1
   start=1

where /dev/Mda is a symlink to /dev/md/d0, because lilo thinks it
understands device names that start "/dev/md".
The "start=" number is fairly important - lilo cannot or does not
figure this out itself, so you have to tell it.  It is the start of
/dev/md/d0p1 in /dev/md/d0.


> 
> But if it works it would probably eventually be possible to add ICH5-R
> etc raid1 superblock support to it. Or just write a valid ICH5-R
> raid1 superblock to the disk (hopefully at another offset) so that the
> BIOS knows this is a RAID1 setup and can boot when sda/hda is dead.

Not knowing anything about ICH5-R superblocks, I cannot comment, but I
would like to be able to support multiple superblock formats.
> 
> BTW, if you want to boot from a partitionable raid, you need the /dev/root
> patch I posted before or you can't check the root filesystem. That patch
> I think will not be accepted since stat(/dev/root) and
> fd=open(/dev/root);fstat(fd) will return different things which is
> inconsequent. How do you feel about applying for a static device number
> for partitioned raid ? Hpa is also on this list, I noticed, and from his
> reaction I think it wouldn't be a problem. Also it would be easier for
> bootloaders like LILO to detect and deal with this.
> 
> Besides, if you check the current devices.txt you'll see that although
> we've almost run out of majors that's only true for character devices.
> There's plenty, plenty of block majors left.

I realise that we could get a major allocated, but I would rather not.
As there seems to be a push for dynamic device numbers, I would like
to ride with it and find out all the implications.

NeilBrown
