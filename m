From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: How to recover after md crash during reshape?
Date: Tue, 20 Oct 2015 14:04:33 +0100
Message-ID: <56263BE1.8070102@youngman.org.uk>
References: <04cdcd6bd69b3aa1f8f24465f8485c90@tantosonline.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <04cdcd6bd69b3aa1f8f24465f8485c90@tantosonline.com>
Sender: linux-raid-owner@vger.kernel.org
To: andras@tantosonline.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20/10/15 03:35, andras@tantosonline.com wrote:
> From here on, things went downhill pretty damn fast. I was not able to
> unmount the file-system, stop or re-start the array (/proc/mdstat went
> away), any process trying to touch /dev/md1 hung, so eventually, I run
> out of options and hit the reset button on the machine.
> 
> Upon reboot, the array wouldn't assemble, it was complaining that SDA
> and SDA1 had the same superblock info on it.
> 
> mdadm: WARNING /dev/sda and /dev/sda1 appear to have very similar
> superblocks.
>       If they are really different, please --zero the superblock on one
>       If they are the same or overlap, please remove one from the
>       DEVICE list in mdadm.conf.
> 
> At this point, I looked at the drives and it appeared that the drive
> letters got re-arranged by the kernel. My three new HDD-s (which used to
> be SDH, SDI, SDJ) now appear as SDA, SDB and SDD.
> 
> I've read up on this a little and everyone seemed to suggest that you
> repair this super-block corruption by zeroing out the suport-block, so I
> did:
> 
>     mdadm --zero-superblock /dev/sda1

OUCH !!!

REALLY REALLY REALLY don't do anything now until the experts chime in !!!

It looks to me like you have a 0.9 superblock, and this error message is
both common and erroneous. There's only one superblock, but it looks to
mdadm like it's both a disk superblock and a partition superblock.
You've just wiped those drives, I think ...

The experts should be able to recover it for you (I hope), but your
array is now damaged - don't damage it any further !!!

Cheers,
Wol
