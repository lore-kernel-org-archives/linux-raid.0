From: Nix <nix@esperi.org.uk>
Subject: Re: Multiple raids on one machine?
Date: Tue, 27 Jun 2006 17:08:59 +0100
Message-ID: <87odwefun8.fsf@hades.wkstn.nix>
References: <449F100D.6030509@cjx.com> <871wtahqgo.fsf@hades.wkstn.nix>
	<44A117A3.5040203@cjx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44A117A3.5040203@cjx.com> (Chris Allen's message of "Tue, 27 Jun 2006 12:33:55 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Chris Allen <chris@cjx.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 27 Jun 2006, Chris Allen wondered:
> Nix wrote:
>> There is a third alternative which can be useful if you have a mess of
>> drives of widely-differing capacities: make several RAID arrays so as to tesselate
>> space across all the drives, and then pile an LVM on the top of all of them to
>> fuse them back into one again.
> 
> But won't I be stuck with the same problem? ie I'll have a single 12TB
> lvm, and won't be able to use EXT3 on it?

Not without ext3 patches (until the very-large-ext3 patches now pending
on l-k go in), sure. But because it's LVMed you could cut it into a couple
of exg3 filesystems easily. (I find it hard to imagine a single *directory*
whose children contain 12Tb of files in a form that you can't cut into
pieces with suitable use of bind mounts, but still, perhaps such exists.)

-- 
`NB: Anyone suggesting that we should say "Tibibytes" instead of
 Terabytes there will be hunted down and brutally slain.
 That is all.' --- Matthew Wilcox
