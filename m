From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: Zero Superblock... any ways to recover?
Date: Mon, 01 Mar 2004 14:31:07 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40438F7B.2CAE0B21@SteelEye.com>
References: <E1AxoKd-0004GZ-00@intern.SerNet.DE> <20040301181240.GC4340@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Luca Berra wrote:
> 
> On Mon, Mar 01, 2004 at 03:23:43PM +0100, Timo.Bolse@SerNet.DE wrote:

> >pentium-test:/proc/ide # mdadm -E /dev/hdc
> >mdadm: No super block found on /dev/hdc (Expected magic a92b4efc, got 00000000)
> >
> >There must be a way to find the superblock on the new device... is there anyone
> >who has a solution for this problem?
> >
> >I thougt about searching for a92b4efc on the device...

If you know how the array was configured, you could just re-create it,
which will create a new superblock in the correct location. But if you
aren't sure, and you want to search for the superblock, you can do:

dd if=/dev/hdc bs=512 | od -A d -h | grep "4efc a92b"

That will give you the offset of the superblock.


> if you know the size of the old device you can find it starting at
> (sector aligned) DEVICE_SIZE - 64k

Actually, the superblock is going to be at:

sb_offset = size - (size % 64k) - 64k

So the superblock is actually somewhere between 64k and 128k from the
end of the (old) device.

--
Paul
