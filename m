From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: mdadm and automatic re-add / incremental mode with usb-disk
Date: Sun, 30 Nov 2008 08:10:51 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0811300808180.29266@p34.internal.lan>
References: <200811301231.58180.wilhelm.meier@fh-kl.de> <alpine.DEB.1.10.0811300646440.29266@p34.internal.lan> <200811301403.29920.wilhelm.meier@fh-kl.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200811301403.29920.wilhelm.meier@fh-kl.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wilhelm Meier <wilhelm.meier@fh-kl.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sun, 30 Nov 2008, Wilhelm Meier wrote:

> Am Sonntag 30 November 2008 schrieb Justin Piszcz:
>> On Sun, 30 Nov 2008, Wilhelm Meier wrote:

> That might be, but what is the difference between doing the re-add and
> re-sync on boot (that's what happens!) or if the drive comes back on
> a running system.

From the docs, when you remove and re-add it would appear to be a 'reocover'
whereas an unclean shutdown would be resyncing (or repair if you do not have
a bitmap).

linux-2.6.27.7/Documentation/md.txt (actually a good doc to read btw)

        resync        - redundancy is being recalculated after unclean
                        shutdown or creation
        recover       - a hot spare is being built to replace a
                        failed/missing device
        repair        - A full check and repair is happening.  This is
                        similar to 'resync', but was requested by the
                        user, and the write-intent bitmap is NOT used to
            optimise the process.

>
> mdadm can surely determine the state/uuid and do this - the same as on
> reboot.
>
>> When you have a failed drive and you re-attach it, it will stay as
>> a removed unit and you need to remove it and add it manually as you
>> stated.
>
> the only thing I have to do is e.g.
>
> mdadm --re-add /dev/md1000 /dev/sdg1
>
> then it starts reconstructing the right way.
>
> So, my thought was to do this as part of a udev-rule.
> But I think this is a common case and therefore there should be a
> well-known solution
Yeah I suppose you could do something like this.  Is the purpose more or less
to have a portable raid1 array?

Justin.

