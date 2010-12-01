From: Phil Turmel <philip@turmel.org>
Subject: Re: [linux-lvm] Q: LVM over RAID, or plain disks? A:"Yes" = best
 of both worlds?
Date: Wed, 01 Dec 2010 07:50:29 -0500
Message-ID: <4CF64495.80700@turmel.org>
References: <AANLkTimTYse7vnqZydc1Z5z60vNuQw3juj7J_W7+bQEm@mail.gmail.com>	<AANLkTimGkMJGiJC+7L+Pu3+yf-J_s0Ex3hM2-g-0+UqQ@mail.gmail.com>	<4CF3F7A0.2080108@rjl.com>	<AANLkTim67atrgHEzunBRvp4ij+MUDiTg4vu5t6sbgFLq@mail.gmail.com>	<4CF4A472.20107@rjl.com>	<AANLkTing5ApAXM2o0M+pxNvg01mHewNgGGBiUXM3aLzZ@mail.gmail.com>	<4CF4F85C.1020806@turmel.org>	<AANLkTi=F5Ttrp9-_wto4ZNWiDvY=cPe0_p26BPyzvMDz@mail.gmail.com>	<4CF52CA5.1090405@turmel.org> <AANLkTin4f=W69mr923KhSYT_qvFnLiz0fpScWo0w1rfu@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTin4f=W69mr923KhSYT_qvFnLiz0fpScWo0w1rfu@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: hansbkk@gmail.com
Cc: linux-raid@vger.kernel.org, linux-lvm@redhat.com
List-Id: linux-raid.ids

On 11/30/2010 11:45 PM, hansbkk@gmail.com wrote:
> On Tue, Nov 30, 2010 at 11:56 PM, Phil Turmel <philip@turmel.org> wrote:
> 
>> (Actually, rsync and tar are both hardlink-aware, at least the versions I use.)
> 
> My backup filesystems contain so many hardlinks (millions, constantly
> growing) that file-level tools choke - this really must be done at the
> block device level - see my previous post for more detail.

Ah -- I did miss that detail.

> It's also now clear to me that rsync is the tool to use for this for
> all the other LVs without such problematic filesystems, as I know the
> tool and trust its error-checking routines.

Indeed.  I push my own critical systems offsite with rsync+ssh.

[snip /]

>> I would use dd.
> 
> OK, that's clear, thanks.
> 
> 
>> You want your dismountable disks to be accessible stand-alone, but I don't see why that would preclude setting them up so each is a unique LVM VG.
> 
> It doesn't preclude it, but it's a layer of complexity during the data
> recovery process I'm trying to avoid.
> 
> The ultimate goal is a plain partition on a plain disk that can be
> directly mounted on a SATA2 host via a normal recovery/LiveCD by a
> user that's never heard of RAID or LVM.

Ah -- not *you*.  And you wouldn't be mixing customers on a disk, I presume?

> To summarize your feedback:
> 
>   - mdraid's sync error-checking routines don't add value over dd to
> ensure accurate cloning of a static partition; its metadata is just
> useless overhead in this case.

Right.

>   - dd is reliable enough

I guess if your filer lacks ECC ram, you could have a bit flip between reading and writing that would be missed.  It's really an end-to-end hardware integrity issue at this level.  But an undetected read error between the platter and RAM will be propagated by every block-level software tool out there, including software raid.  btrfs can do data-checksumming, but that's at the FS level.

> One last question (and I do realize it's now OT for here, so I won't
> be hurt if it's ignored :)
> 
> Does dd already do some sort of "verify after copy"? I will likely
> investigate the available COTS partition cloning tools as well.

Not natively, but it fairly easy to pipe a dd reader through md5sum to a dd writer, then follow up with a dd read + md5sum of the copied partition (taking care to read precisely the same number of sectors).

The various flavors of ddrescue might have something like this..  didn't check.

> Thanks for all your help, not least in helping me to clarify my own goals

You're welcome.

Phil
