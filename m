From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Software RAID and Fakeraid
Date: Tue, 30 Nov 2010 14:54:40 -0500
Message-ID: <4CF55680.5010703@cfl.rr.com>
References: <AANLkTinhWh4FQ7q=Vkym_fd9aucXLMhgzgFuw23Z9o59@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinhWh4FQ7q=Vkym_fd9aucXLMhgzgFuw23Z9o59@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: The development of GNU GRUB <grub-devel@gnu.org>
Cc: John Sheu <john.sheu@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/25/2010 5:26 AM, John Sheu wrote:
> What's the preferred way to differentiate BIOS fakeraid from regular
> software mdraid?

The only way I know of is detecting that it is a dmraid device as
opposed to md, which is why grub does it that way.  This worked well in
the past when each tool exclusively handled one type of raid.

> I ask this as I'm booting with GRUB2 off a system that has one of those
> Intel fakeraid chipsets.  As of a few months ago, the mdadm package has
> supported these fakeraid setups, so the RAID array comes up as a /dev/md###
> device.  This is unfortunate, as GRUB2 assumes that any device of the type
> /dev/md### must be a pure software RAID device, and in
> util/grub-setup.c:939, tries to install itself to the RAID members
> individually:

For grub to support fakeraids activated by the md driver, it needs some
way to find out that it is actually a fake raid, and not a software
raid.  Adding linux-raid to Cc list to see if they can suggest a way of
doing that.
