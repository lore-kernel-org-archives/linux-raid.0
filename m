From: bfowler@ewitness.co.uk (ewitness - Ben Fowler)
Subject: Re: recovery of software raid0
Date: Fri, 14 Jun 2002 23:47:24 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <f04330104b93020a6aa73@[192.168.254.57]>
References: <Pine.LNX.4.31L.02.0206141758490.21148-100000@linux1.gl.umbc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.31L.02.0206141758490.21148-100000@linux1.gl.umbc.edu>
To: Maxwell Bottiger <mbotti1@gl.umbc.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

At 6:06 pm -0400 14/6/02, Maxwell Bottiger wrote:
>So, my system was hacked today and everything is a mess.  I need to get to
>two raid 0 partitions and recover the data off of them before I wipe and
>clean the system.
>
>The problem is that I have no root partition or much of any other system
>directories.  It appears all my raid partitons are in good shape, but I
>need to mount them from something like my rescue disk.  How can I go about
>doing this?  I no longer have a raidtab or fstab, but I know which
>partitons go together and I'm 99% sure they all have persistant
>superblocks so they shoud be easily reccognized.

I am sorry to hear of your misfortune. Please do nothing hasty, and
if possible get advice from someone who has been through this. There is
a good chance that you can get almost all of your home directory
back, given time.

First, if you have the install CD from a modern SuSE distribution,
you may find that it will recognise the RAID and partitions.

>If this is simply a matter of putting in a temporary raidtab file could
>someone please send me a sample one?  Also, would someone please give me
>an example of what arguments to give mount in order to mount the disks
>propperly.

Yes. I suspect that you need a raidtab. You are outside the area
that I can work from by remote control, but I presume that you can
boot from Tom's Root and Boot Disk or your distribution's install
CD and dummy up a raidtab.

You will be lucky if anything mounts. If you are using Reiser's
FS you recover your data by scavenging otherwise open the device
in a file system debugger.

Wait for someone else to confirm and/or give more detail.

'Phone a friend' as they say, and bribe him or her with, say,
coffee molecules. Recovery from this is time consuming and
tedious, but should be possible.

>If it is possible to get back to me about this quickly please do.  I
>really need to get this box back online, everything I have is in those
>home directories.

Online?

Don't take action too quickly - more haste less data!

Ben.
