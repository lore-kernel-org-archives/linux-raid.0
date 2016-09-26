From: Phil Turmel <philip@turmel.org>
Subject: Re: Linux raid wiki - setting up a system - advice wanted :-)
Date: Mon, 26 Sep 2016 10:13:35 -0400
Message-ID: <e5651061-1404-30be-2777-9ae02a640f42@turmel.org>
References: <57E83EA8.9060809@youngman.org.uk>
 <20160926021622.GA25056@metamorpher.de> <57E8C550.8000509@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57E8C550.8000509@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/26/2016 02:50 AM, Wols Lists wrote:

> Bare metal -> raid [-> lvm] -> /
> 
> Is there any room on the disk to install grub?

No.

> (Note that - and I know you shouldn't believe everything you read on the
> internet - apparently Neil Brown prefers passing the entire
> unpartitioned disk to raid ...)

I'm with Neil for my large arrays.  I partition a pair of SSDs for UEFI
boot and a raid mirror holding an LVM volume group for the OS.  All
other drives are unpartitioned, given entirely to a raid6 w/ a small
chunk size (16k lately).  A separate LVM volume group on top of that.

( I no longer use any bootloader, either, as UEFI will boot a kernel
directly that's been built with EFI_STUB and a nested initramfs. )

Phil

