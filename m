From: Nix <nix@esperi.org.uk>
Subject: Re: Linux RAID version question
Date: Fri, 24 Nov 2006 22:24:39 +0000
Message-ID: <87d57ciiu0.fsf@hades.wkstn.nix>
References: <d33135570611231749p2d24eb51r7fc5a518afada0cd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d33135570611231749p2d24eb51r7fc5a518afada0cd@mail.gmail.com> (Dragan Marinkovic's message of "24 Nov 2006 01:49:33 -0000")
Sender: linux-raid-owner@vger.kernel.org
To: Dragan Marinkovic <marinkovic.dragan@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 24 Nov 2006, Dragan Marinkovic stated:
> I think that both issues are resolved with metadata version 1 in
> kernel 2.6.18 . Is this correct or there are patches to be applied for
> both issues?

That's correct.

> Is the subversion of metadata version 1 important (there are 1, 1.0,
> 1.1 and 1.2)? If it is, which one is the best to use from the
> stability point of view?

The version numbers simply indicate where the superblock is stored on
the individual component devices.

Version 1.0 is stored near the end of the device (at least 8K, and less
than 12K, from the end). This is useful, especially with RAID-0 and
RAID-10 devices, because the RAID filesystem and non-RAID filesystem
starts in exactly the same place, so if you can't get RAID up you can
often mount the thing directly in readonly mode and get the data
off. But it has the tiny risk that writing off the end of the filesystem
(when it's mounted without going through md like that) will wreck your
array.

Version 1.1 is stored at the start of the device. This eliminates the
overwriting thing but stops you from directly mounting without going
through md.

Version 1.2 is like version 1.1 but stores the superblock 4K from the
device start. This is particularly useful if you make a RAID array on a
whole device, because this misses partition tables, master boot records,
and the like.

In practice they're nearly identical, sharing nearly all of their code:
I happen to use version 1.2 here but that was a nearly arbitrary choice.

The kernel automounter can't mount any of the version 1.x superblocks,
and LILO can't boot off them, so I've used 0.90.x for the tiny /boot md
array and rely on an initramfs to assemble the rest and find the root
filesystem on it (which is in LVM as well, so I'd need an initramfs or
initrd anyway to assemble *that*.)

-- 
`The main high-level difference between Emacs and (say) UNIX, Windows,
 or BeOS... is that Emacs boots quicker.' --- PdS
