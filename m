From: Nix <nix@esperi.org.uk>
Subject: Re: Starting point of the actual RAID data area
Date: Wed, 11 Oct 2006 23:16:06 +0100
Message-ID: <87ejte5wih.fsf@hades.wkstn.nix>
References: <2341BC7C-A023-4E59-8D2E-773EC9AF031E@dataprey.fi>
	<87hcyfpr7a.fsf@rimspace.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87hcyfpr7a.fsf@rimspace.net> (Daniel Pittman's message of "8 Oct 2006 02:13:54 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Pittman <daniel@rimspace.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 8 Oct 2006, Daniel Pittman said:
> Jyri Hovila <jyri.hovila@dataprey.fi> writes:
>> I would appreciate it a lot if somebody could give me a hand here. All
>> I need to understand right now is how I can find out the first sector
>> of the actual RAID data. I'm starting with a simple configuration,
>> where there are three identical drives, all of them used fully for one
>> RAID 5 set. And no LVM at this point.
> 
> It would start on the first sector of the first disk.

That depends on the superblock version. Versions 0.9x and 1.0 will do as
you say, but versions 1.1 and 1.2 will have the start of the disk
holding either the RAID superblock (for 1.1) or 4Kb of nothing (for
1.2).

-- 
`In typical emacs fashion, it is both absurdly ornate and
 still not really what one wanted.' --- jdev
