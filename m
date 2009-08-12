From: Neil Brown <neilb@suse.de>
Subject: Re: Prevent automatic reconstruction during boot/assembly (RAID 1)?
Date: Thu, 13 Aug 2009 09:10:09 +1000
Message-ID: <19075.19409.877554.418049@notabene.brown>
References: <2953e180908110528u705fc002m6c799821fe278375@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Sebastian Farber on Tuesday August 11
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Sebastian_F=E4rber?= <faerber@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday August 11, faerber@gmail.com wrote:
> Hi,
> 
> i'm trying to figure out if it is possible to prevent the
> automatic reconstruction that can occur during the md assembly
> at boot.
> I'm running Kernel 2.6.30.4 and use a RAID-1 over two SATA disks.
> If the server is rebooted "hard" due to power loss etc. it often happens
> that the reconstruction of my RAID-1 is automatically triggered by the kernel.
> Is there any way to prevent this? I want to re-add the "out of sync"
> drive myself
> using mdadm only.
> I'm currently using raid auto detection (partiton type fd) and the old
> 0.90 superblock format but if it helps i would switch
> to an initrd/newer superblock.

There isn't any simple way to do what you want.
May if you could explain why you want it, something else might be
suitable.

NeilBrown
