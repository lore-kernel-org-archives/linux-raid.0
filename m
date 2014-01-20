From: Phil Turmel <philip@turmel.org>
Subject: Re: If separate md for /boot, OS, and /srv, must 'create' on disks
 with 3 partns?
Date: Mon, 20 Jan 2014 13:29:52 -0500
Message-ID: <52DD6B20.5030906@turmel.org>
References: <52DC1BED.7070901@tesco.net> <52DC39A7.5020506@turmel.org> <52DD5471.4070809@tesco.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52DD5471.4070809@tesco.net>
Sender: linux-raid-owner@vger.kernel.org
To: Ron Leach <ronleach@tesco.net>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/20/2014 11:53 AM, Ron Leach wrote:
> On 19/01/2014 20:46, Phil Turmel wrote:
>> On 01/19/2014 01:39 PM, Ron Leach wrote:
>>> Assuming I am correct in needing something such as:
>>>
>>> /dev/md0 for Grub, (and copied to both physical disks of the RAID-1)
>>> /dev/md1 for the OS, and
>>
>> I would use LVM here, too.
> 
> I wondered.  Would also enable me to reserve much less space for the OS
> and one or two small services that might be run there.  I'll read up on
> Grub over LVM, which is the only thing I'm not familiar with.

Let me clarify:  /dev/md0 should be a v0.90 or v1.0 raid1 for /boot, no LVM.

/dev/md1 is an LVM PV for the OS.

> Thanks for the guidance, and for confirming that separate RAID1s does
> imply separate partitions on the physical devices.  I've noted your (and
> David's, in another post) concerns about bandwidth and RAM.  I'll look
> into booting into the LVM, that's new to me.

The key is to have both MD and LVM support in your initramfs that gets
loaded by grub with your kernel.  All the major distributions will do
this for you if you create the OS on LVM in the first place.

They'll usually let grub find your root filesystem UUID and put it into
the kernel command line.  You can override that with an explicit
root=LABEL= or root=UUID= setting in /etc/default/grub.

Having root in an LVM allows strange things like relocating and/or
resizing it on the fly.  Particularly handy if physical access is difficult.

HTH,

Phil

