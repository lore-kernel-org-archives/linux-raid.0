From: Ed W <lists@wildgooses.com>
Subject: Re: Software raid, booting and bios
Date: Fri, 20 May 2011 20:13:41 +0100
Message-ID: <4DD6BD65.7020702@wildgooses.com>
References: <9067914580344941270@unknownmsgid> <ir58vs$9qp$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ir58vs$9qp$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Paul van der Vlis <paul@vandervlis.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20/05/2011 09:33, Paul van der Vlis wrote:
> You can select the "boot device priority" where you can choose about
> devices types (DVD, harddisk, USB, network) but you can choose only one
> SATA disk. Study it, and you will see I am right. I've asked it to my
> rackserver-vendor, they say: "that's always the case".

Hi, what I have done with all my supermicro servers is to buy a tiny USB
flash drive (physically small, not capacity small) - I think what I
bought might be one of the tiny PNY devices, not sure though

The Supermicro boards have internal USB headers mounted on the
motherboard, even with a 1U server I have plenty of room to install my
USB on the MB (could stick them out the back of the server and cable tie
them (or superglue them))

Then I put SysrescueCD on my stick and setup GRUB with a bunch of boot
options.

In my case I'm under the possibly misguided apprehension that my boot
will fail over to the spare disks if one fails. However, I can set the
subsequent failover to be my USB stick also.  I think I have them set at
the moment that the USB stick boots the main drives as normal, but has a
boot menu where I can also boot the sysrescueimage if I need to (I use
this (over IPMI) for initial system installation and serious
maintenance, eg failed grub upgrade or similar).

The only other option that I think the big hosting guys use is to have a
netboot setup which boots everything and can also offer rescue images,
etc.  Beyond my skills to setup for my meagre number of servers, but if
you have more than a couple of machines this could be a very good solution?

For my needs the USB stick option is perfect

Sysrescuecd suits me because all my servers are gentoo based - clearly
it will work for other distros also, but you might want to evaluate
other rescue distros before choosing one?

Good luck

Ed W
