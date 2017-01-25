From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: errors when reading in one section of a disk
Date: Wed, 25 Jan 2017 16:42:18 +0000
Message-ID: <5888D56A.3050409@youngman.org.uk>
References: <3b82fbda-b3a7-4bcf-8c1e-cbb2b2fd7075@exhybrid01.net.ucsf.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3b82fbda-b3a7-4bcf-8c1e-cbb2b2fd7075@exhybrid01.net.ucsf.edu>
Sender: linux-raid-owner@vger.kernel.org
To: "Boylan, Ross" <Ross.Boylan@ucsf.edu>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 25/01/17 02:43, Boylan, Ross wrote:
> It looks as if the RAID arrays survive the redefinition of the physical devices (e.g., sde is reattached as sdj), but it's hard to tell since the partition with the error is mounted read-only and thus generates errors.  I have been rebooting the whole system shortly after the problem happens.  Should  the /dev/md* devices survive such remapping beneath them?
> 
Everything is moving to UUIDs. And raid, iirc, has done so.

In other words, when your system is running, it doesn't care what you
refer to the drives as - sde or sdj is immaterial - it converts those to
UUIDs before saving them in the config, so when it re-assembles the
array after some sort of reset, it gets the right drive. Linux has a
whole bunch of symlinks in /dev to make life easy for the sysadm, and
raid does what makes life easy for it.

Thing is, udev explicitly does NOT guarantee things like sda, sdb, etc
(and md0, md1`, md27, md126 etc) will be preserved - they are allocated
in the order the devices are found and there are quite a few systems out
there that are distinctly non-deterministic so all the little quirks
WILL have been found and ironed out. It's just "fortunate" that PC
hardware happens to be - for the most part - deterministic giving the
same result every time.

> After the remapping the file systems the md devices supported on the host computer were still mounted (albeit ro for one of them). mdadm -D did not llist the names of the component devices and the info in proc (or maybe it was run) seemed stale, since it still had the old device names (e.g., sde3 rather than sdj3).

I'm guessing linux reset the Vantec box, rediscovering and moving all
the drives, but raid didn't realise anything had happened so it was
still using the old names. Not a good place to be, I don't think...

Cheers,
Wol
