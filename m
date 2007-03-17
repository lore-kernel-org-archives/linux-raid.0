From: Nix <nix@esperi.org.uk>
Subject: Re: mdadm file system type check
Date: Sat, 17 Mar 2007 23:08:48 +0000
Message-ID: <87wt1fmprz.fsf@hades.wkstn.nix>
References: <1174089424.22511.26.camel@wlt.obsidian-studios.com>
	<45FB46DA.7090307@panix.com> <1174123640.12326.10.camel@scotgate>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1174123640.12326.10.camel@scotgate> (Chris Lindley's message of "17 Mar 2007 09:53:52 -0000")
Sender: linux-raid-owner@vger.kernel.org
To: Chris Lindley <ferg@scotgate.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 17 Mar 2007, Chris Lindley told this:

> What I think the OP is getting at is that MDADM will create an array
> with partitions whose type is not set to FD (Linux Raid Auto), but are
> perhaps 83.
>
> The issue with that is that upon a reboot mdadm will not be able to
> start the array.

I think you mean that the Linux kernel's auto-assembly code won't be
able to start the array. mdadm doesn't care.

>                   If you use MDADM to manually reassemble the array then
> it will work fine. But until you reset the partition type to be FD, you
> will have to run this step every time you reboot the machine.

That's what initramfs/initrd is good at :)

-- 
`In the future, company names will be a 32-character hex string.'
  --- Bruce Schneier on the shortage of company names
