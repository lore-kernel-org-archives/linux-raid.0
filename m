From: David Brown <david.brown@hesbynett.no>
Subject: Re: Soft RAID and EFI systems
Date: Mon, 03 Feb 2014 10:56:43 +0100
Message-ID: <52EF67DB.9030403@hesbynett.no>
References: <CAC9WiBjSjBw8Y=cCd8bpwQhuy-1+swYVdHkBT7bynv6Hx8_6zA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBjSjBw8Y=cCd8bpwQhuy-1+swYVdHkBT7bynv6Hx8_6zA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 31/01/14 18:02, Francis Moreau wrote:
> Hello,
> 
> On EFI systems I'd like to RAID mirror /boot partition.
> 
> For HW RAID there's no issue since access to the disk or any
> partitions should be totally transparent to the bios.
> 
> For Fake RAID, I'm not sure but I would say that the bios is able to
> read the RAID metadata as well.
> 
> For (md) Soft RAID, I don't know. I would say that the bios is
> unlikely to understand the md metadata stored in the /boot partition
> so it won't work.
> Is that correct ?
> If so does that mean I can't mirror /boot partition on EFI systems ?
> Maybe creating a RAID device using the whole disk (not the partition
> device) would work ?
> 
> Thanks for your enlightments.
> 

I can't answer your question as such, but in case you don't know
VirtualBox virtual machines can be configured with an EFI instead of a
normal bios.  I don't know how complete the emulation of EFI is, but
that might give you a quick and easy way to test out the different ideas.

