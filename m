From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: metadata and / and grub-static
Date: Mon, 05 Apr 2010 15:55:32 +0100
Message-ID: <4BB9F9E4.2060802@anonymous.org.uk>
References: <u2u5bdc1c8b1004041902l9edc298dg6fb4774aaf8c22a6@mail.gmail.com>	 <2D.29.28131.56A49BB4@cdptpa-omtalb.mail.rr.com> <r2m5bdc1c8b1004050715q6db273f9o8d1c291a43ebd308@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <r2m5bdc1c8b1004050715q6db273f9o8d1c291a43ebd308@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/04/2010 15:15, Mark Knecht wrote:
> On Sun, Apr 4, 2010 at 7:26 PM, Leslie Rhorer <lrhorer@satx.rr.com> wrote:
> <SNIP>
>>> Answering self - putting / on RAID1 only seems to work using
>>> --metadata=0.90. Tried it with higher versions and had no luck.
>>        One may most certainly run a RAID1 / or /boot (or both) using other
>> than 0.9 metadata.  I'm running two servers with / on a 1.02 superblock and
>> /boot on a 1.0 superblock, booting with grub 0.97.
> 
> Are you using an initrd? I could not make it work above 0.90 without
> going that way which I didn't want to do.

Yes, the kernel will only auto-assemble arrays with 0.90 metadata, and 
Neil Brown has stated several times that there never will be support for 
auto-assembling anything else in the kernel.

You can still have your /boot with 1.0 metadata using grub 0.97 (or even 
LILO) and your root with any metadata but you will need an initrd 
containing mdadm with which to assemble your arrays before attempting to 
mount the root filesystem.

But if you're determined to avoid an initrd, you're stuck with 0.90 
metadata for your root filesystem. This probably isn't much of a 
limitation since you can still have a 27-drive RAID-6 array of 2TB discs 
with write-intent bitmap if you want. (It might even be 28 discs.) And 
if you had an array as funky as that, you'd probably want to run LVM 
over the top of it, so you'd need an initrd anyway, so you'd be able to 
use 1.x metadata :-)

Since most distros ship highly modular kernels, their installers and 
tools all build initrds, so for most people, needing an initrd is not an 
issue.

Anyway, a quick summary:
* with grub 0.97 or LILO, /boot (more generally, wherever your vmlinuz 
lives) must be RAID-1 on 0.90 or 1.0 metadata, and the members must be 
on drives the BIOS will boot from, usually sda/b/c
* without an initrd, / must be on 0.90 metadata but any RAID level or 
disc location (that the kernel doesn't need extra modules for) is fine
* and combining these, if you're running grub 0.97 (or LILO) and don't 
want a separate /boot array (or keep your vmlinuz in the root) and don't 
want to use an initrd, you're restricted to having your root filesystem 
on RAID-1 on 0.90 metadata on drives the BIOS will boot from

Cheers,

John.

