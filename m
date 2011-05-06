From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: mdadm raid1 read performance
Date: Fri, 6 May 2011 16:05:24 -0500
Message-ID: <E8.69.09483.F8264CD4@cdptpa-omtalb.mail.rr.com>
References: <iptjde$92f$1@dough.gmane.org>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <iptjde$92f$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'David Brown' <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of David Brown
> Sent: Thursday, May 05, 2011 2:27 AM
> To: linux-raid@vger.kernel.org
> Subject: Re: mdadm raid1 read performance
> 
> On 05/05/2011 02:40, Liam Kurmos wrote:
> > Cheers Roberto,
> >
> > I've got the gist of the far layout from looking at wikipedia. There
> > is some clever stuff going on that i had never considered.
> > i'm going for f2 for my system drive.
> >
> > Liam
> >
> 
> For general use, raid10,f2 is often the best choice.  The only
> disadvantage is if you have applications that make a lot of synchronised
> writes, as writes take longer (everything must be written twice, and
> because the data is spread out there is more head movement).  For most
> writes this doesn't matter - the OS caches the writes, and the app
> continues on its way, so the writes are done when the disks are not
> otherwise used.  But if you have synchronous writes, so that the app
> will wait for the write to complete, it will be slower (compared to
> raid10,n2 or raid10,o2).
> 
> The other problem with raid10 layout is booting - bootloaders don't much
> like it.  The very latest version of grub, IIRC, can boot from raid10 -
> but it can be awkward.  There are lots of how-tos around the web for
> booting when you have raid, but by far the easiest is to divide your
> disks into partitions:
> 
> sdX1 = 1GB
> sdX2 = xGB
> sdX3 = yGB
> 
> Put all your sdX1 partitions together as raid1 with metadata layout
> 0.90, format as ext3 and use it as /boot.  Any bootloader will work fine
> with that (don't forget to install grub on each disk's MBR).
> 
> Put your sdX2 partitions together as raid10,f2 for swap.
> 
> Put the sdX3 partitions together as raid10,f2 for everything else.  The
> most flexible choice is to use LVM here and make logical partitions for
> /, /home, /usr, etc.  But you can also partition up the md device in
> distinct fixed partitions for /, /home, etc. if you want.

	I agree, except that I like to have separate physical devices for
booting and raw disks for the data.  My servers each have a pair of 500G
hard drives partitioned into three sections.  First, /dev/sdX1 is a small
partition which contains only /boot, it is read-only, and can be mounted at
boot time, or not.  As you say, it has a 0.90 superblock, although I chose
an ext2 file system.  Next, /dev/sdX2 uses about half the disk and is
mounted at /.  Finally, I use the rest of the disk, /dev/sdX3, as swap
space.  I chose all three to be RAID1.

	The data drives are all >= 1Tb, unpartitioned, and assembled into
RAID6 arrays of 10 or more members, each.

	These systems use so little swap space and so rarely, I'm not sure I
see any benefit to RAID10,f2 for them.  Is there?

