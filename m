From: Nix <nix@esperi.org.uk>
Subject: Re: Still can't get md arrays that were started from an initrd to shutdown
Date: Tue, 18 Jul 2006 00:35:00 +0100
Message-ID: <87ac77dcuz.fsf@hades.wkstn.nix>
References: <bb145bd20607171355x8143b0eofb0017637d749263@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bb145bd20607171355x8143b0eofb0017637d749263@mail.gmail.com> (Christian Pernegger's message of "17 Jul 2006 21:56:11 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Christian Pernegger <pernegger@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 17 Jul 2006, Christian Pernegger suggested tentatively:
> I'm still having problems with some md arrays not shutting down
> cleanly on halt / reboot.
> 
> The problem seems to affect only arrays that are started via an
> initrd, even if they do not have the root filesystem on them.
> That's all arrays if they're either managed by EVMS or the
> ramdisk-creator is initramfs-tools. For yaird-generated initrds only
> the array with root on it is affected.

Hm. FWIW mine (started via initramfs) all shut down happily, so
something more than this is involved.

My initramfs has a /dev populated via busybox's `mdev -s', yielding
a /dev containing all devices the kernel reports, under their kernel
names. mdadm is run like this:

/sbin/mdadm --assemble --scan --auto=md --run

and, well, it works, with udev populating the appropriate devices for me
once we switch to the real root filesystem.

> If only there were an exitrd imge to comlement the initrds ...

This shouldn't be necessary.

One possible difference here is that switch_root (from recent busyboxes)
deletes everything on the initramfs before chrooting to the new root.
Are you sure that there's nothing left running from your initrd that
could be holding open, say, some block device that comprises part of
your RAID array? (I'm just guessing here, but this seems like the
largest difference between your setup and mine.)

-- 
`We're sysadmins. We deal with the inconceivable so often I can clearly 
 see the need to define levels of inconceivability.' --- Rik Steenwinkel
