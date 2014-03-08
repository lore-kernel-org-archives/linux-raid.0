From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Linux software-RAID and bootloader
Date: Sat, 8 Mar 2014 14:20:48 -0700
Message-ID: <20C9589F-7F5F-49D0-916E-9A6AA6B833BA@colorremedies.com>
References: <CAJx5YvGGM7yziWQEefs=_Wte4jy13w1x1oG6MuUOggSgTfodMQ@mail.gmail.com> <67153819-285E-430A-A745-A96D6ECDA4DB@colorremedies.com> <CAJx5YvF7t=suX8jzQso4cjPPqFgCgBDXiop9i47F+C2A2KtR=g@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJx5YvF7t=suX8jzQso4cjPPqFgCgBDXiop9i47F+C2A2KtR=g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mar 7, 2014, at 9:13 PM, Martin T <m4rtntns@gmail.com> wrote:

> Chris, Peter,
> 
> thank you for this information! So in a nutshell, it's important to
> make sure that partitioning tool leaves enough space between the start
> of the block device and the first partition so that both Linux MD RAID
> and bootloader can both write their data to this area?

My original explaination might be confusing. The offset is 4KB from the *start* of the block device. Block device is defined as any discretely definable block device, that is /dev/sda is a block device, but so is /dev/sda1 and /dev/sda2. So mdadm metadata v 1.2 is offset 4KB from the start of whatever device you point mdadm to.

Therefore if you partition, you wouldn't ever point mdadm to /dev/sda you'd point it to a partition and hence avoid writing metadata to the MBR gap, no matter what the start of the first partition is.

Any recent partition tool starts the first partition at LBA 2048.


> In addition, it's a best practice to mirror MBR/GPT using
> sfdisk/sgdisk(or dd) to each block device in RAID array and then
> install GRUB to each block device separately?

I don't think mdadm is overly fussy about small differences in member device sizes, but sure you can duplicate identical layouts among drives using whatever method is easiest for you. Don't use dd for GPT however, it won't copy the backup GPT.

If BIOS, yes grub-install to each member disk. If UEFI, install to one, and then manually create and copy to the others (for now).


Chris Murphy