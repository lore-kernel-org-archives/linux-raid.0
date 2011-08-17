From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: First raid1 sector gets zeroed at first reboot
Date: Wed, 17 Aug 2011 14:43:34 +0100
Message-ID: <4E4BC586.10109@anonymous.org.uk>
References: <4E4AABF6.2070800@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E4AABF6.2070800@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 16/08/2011 18:42, Asdo wrote:
> Hello all
> sometimes I put grub on the first sector of a MD raid1 device, which is
> on disk partition and not on the whole disk.
> (there is another bootloader in the MBR which chainloads this one, and
> that's not the problem)
>
> Sometimes, and I'm not yet able to reproduce it reliably, that sector
> gets zeroed at first reboot.
>
> So the first reboot after installation of the OS + grub indeed succeeds,
> but the next reboot fails. After the first reboot the first sector of
> such MD device gets zeroed, so at the second reboot the bootloader is
> missing. At that point I have to boot with a live-cd again and reinstall
> Grub in there to be able to boot again.
>
> I totally confirm that the sector is nonzero before the first reboot,
> and is zero after the second reboot. Not sure when exactly it gets
> zeroed but it's between those two points in time. I suspect it becomes
> zero at the first reassemble of the MD device.
>
> After the second reboot the problem won't ever happen again on that
> RAID. And if it hasn't happened by that time it won't ever happen again
> on that RAID.
> I'm thinking at a bug in some RAID initialization procedure which is
> being delayed at the first reassemble of the device... does this ring
> any bell?
>
> The last time it happened to me (that's yesterday) it was with a
> degraded raid-1 (it was created with a missing device) with metadata=1.0
> . I absolutely confirm that dd'ing the first 512bytes sector from the MD
> device and dd'ing the first sector from the underlying partition both
> resulted in a (identical) nonzero sector before the first reboot. After
> the second reboot both were zero.
> Also please note that since it was a degraded raid-1, this excludes a
> resync problem, because there couldn't possibly have been any resync.
>
> Also, the filesystem itself appears intact, so this is a "bug" affecting
> only the very beginning of a MD device.
>
> Anyone knows what's happening?

The first sector of a md RAID with metadata 1.0 is in its data area, so 
there's no way md is writing to this area itself, it's almost certainly 
the filesystem that's writing it.

I think installing grub on a md partition is a bad idea. You can use 
metadata 1.2 to have the first 4K left free, but grub may write its 
stage 1.5 code to the first 31.5K of a device (whole drive or partition).

Cheers,

John.

