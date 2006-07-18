From: Nix <nix@esperi.org.uk>
Subject: Re: only 4 spares and no access to my data
Date: Wed, 19 Jul 2006 00:44:31 +0100
Message-ID: <87ac76bhr4.fsf@hades.wkstn.nix>
References: <loom.20060709T205013-455@post.gmane.org>
	<62b0912f0607091223y3d0a1ab5xbc5fb01ce2a74f9e@mail.gmail.com>
	<loom.20060710T095111-275@post.gmane.org>
	<44B213CD.5010907@idgmail.se>
	<17596.17567.790363.193434@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17596.17567.790363.193434@cse.unsw.edu.au> (Neil Brown's message of "18 Jul 2006 03:18:07 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Henrik Holst <henrik.holst@idgmail.se>, Karl Voit <neww@Karl-Voit.at>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 18 Jul 2006, Neil Brown moaned:
> The superblock locations for sda and sda1 can only be 'one and the
> same' if sda1 is at an offset in sda which is a multiple of 64K, and
> if sda1 ends near the end of sda.  This certainly can happen, but it
> is by no means certain.
> 
> For this reason, version-1 superblocks record the offset of the
> superblock in the device so that if a superblock is written to sda1
> and then read from sda, it will look wrong (wrong offset) and so will
> be ignored (no valid superblock here).

One case where this can happen is Sun slices (and I think BSD disklabels
too), where /dev/sda and /dev/sda1 start at the *same place*.

(This causes amusing problems with LVM vgscan unless the raw devices
are excluded, too.)

-- 
`We're sysadmins. We deal with the inconceivable so often I can clearly 
 see the need to define levels of inconceivability.' --- Rik Steenwinkel
