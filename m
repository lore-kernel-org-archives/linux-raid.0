From: "J. Hart" <af804@bfn.org>
Subject: Re: 2.6.19-rc5: Can't get built-in raid support, modular works correctly
Date: Sat, 21 Jul 2007 01:06:28 +0900
Message-ID: <46A0DD84.1050203@bfn.org>
References: <469F6CFC.5050700@bfn.org> <Pine.LNX.4.64.0707191204010.13957@p34.internal.lan> <469FDD95.1090402@bfn.org> <Pine.LNX.4.64.0707200613170.13189@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0707200613170.13189@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>
List-Id: linux-raid.ids

Justin Piszcz wrote:

> I (normally) do not run -rcX release and I always compile in RAID 
> support and have not seen that issue; then again, I did not try 
> 2.6.19-rc5 that I can remember.

I've just discovered the problem (at 1 am of course).

I'm using Linux with my own custom kernel running on a quad Mac Pro (no 
Parallels, no Bootcamp, no Windows, no OS X etc, and hence no partition 
restrictions.....:-). Since this is an Intel Mac, running grub used to 
be a bit tricky owing to the A20 line problem, so I've been using lilo 
instead.
After building the kernel, I dutifully typed the following, as any good 
lilo believing kernel builder should:

lilo

This ended up placing the boot block on the root partition. I had 
previously told the Mac EFI boot loader to look for it on the MBR of my 
first SATA drive, which in this case is a very different location. What 
I should have used was:

lilo -b /dev/sda

It was booting the old kernel of course, which was the same version 
release as the rebuilt one.

(....slapping forehead.....)

All is working just as expected now.....:-)

Many Thanks for your comments........

