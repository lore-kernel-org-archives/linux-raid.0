From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Enlarging device of linear array again (Thank you Stan!)
Date: Tue, 20 Sep 2016 22:52:00 +0100
Message-ID: <57E1AF80.8000406@youngman.org.uk>
References: <20160920213442.1559310f@hoferr-X240.hofer.rummelring>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160920213442.1559310f@hoferr-X240.hofer.rummelring>
Sender: linux-raid-owner@vger.kernel.org
To: Ramon Hofer <ramonhofer@bluewin.ch>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20/09/16 20:34, Ramon Hofer wrote:
> I am using 4 TB WD red to replace the 1.5 TB disks.
> 
> Do you think this could work?
> Are there any pitfalls?
> Should I unmount the array to perform all these steps? It might be
> safer since there is no redundancy during the replacement?
> 
> I just wanted to check first before making any mistakes. Instead of
> maybe afterwards asking for help recovering my data :-P

I don't quite understand what you are doing, but ...

Do you have four existing drives (sde, sdf, sdg, sdh) and you are
planning on replacing them with four new, larger drives? (It comes over
that you are planning to create four partitions on one drive to replace
the four drives, and that just isn't right).

If you are planning to use four new drives, then the obvious thing is to
get either an add-in pci card to give you more SATA connections, or a
USB adaptor (caveat, I've never done anything like this) so you can
temporarily add in an extra drive.

If you've got an add-in PCI card, stick a new 4TB drive in, use "mdadm
--replace" to move one of the old drives across, and remove the old
drive. Rinse and repeat until all four drives are done.

If you got a USB case, put a new drive in the computer, and the old
drive in the case. Again, use "mdadm --replace" to move the old drive
across, and remove the old drive from the case. Rinse and repeat until
all four drives are done. I believe that it's a lot faster reading from
than writing to USB, hence me saying move the small drive to USB then
copy from it.

That way, at no point is your raid at risk while you're replacing a drive.

The other way to do it is just shut the machine down, remove all drives
except one and put a new big drive in. Boot from a rescue CD, partition
the new drive and dd the old partitions to the new drive. Again rinse
and repeat for all four drives, and then put all four new drives in the
system and reboot. At which point you can expand all the
filesystems/raids to use all the space available. This *shouldn't* be a
risky operation. Indeed, if you're going to shut the array down, this is
probably the simplest and safest option.

Cheers,
Wol
