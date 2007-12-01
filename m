From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Kernel 2.6.23.9 + mdadm 2.6.2-2 + Auto rebuild RAID1?
Date: Sat, 1 Dec 2007 07:12:59 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0712010711380.25643@p34.internal.lan>
References: <Pine.LNX.4.64.0712010614070.25643@p34.internal.lan>
 <Pine.LNX.4.64.0712011305250.30316@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754035AbXLAMNV@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0712011305250.30316@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, apiszcz@solarrain.com
List-Id: linux-raid.ids



On Sat, 1 Dec 2007, Jan Engelhardt wrote:

>
> On Dec 1 2007 06:19, Justin Piszcz wrote:
>
>> RAID1, 0.90.03 superblocks (in order to be compatible with LILO, if
>> you use 1.x superblocks with LILO you can't boot)
>
> Says who? (Don't use LILO ;-)
I like LILO :)

>
>> , and then:
>>
>> /dev/sda1+sdb1 <-> /dev/md0 <-> swap
>> /dev/sda2+sdb2 <-> /dev/md1 <-> /boot (ext3)
>> /dev/sda3+sdb3 <-> /dev/md2 <-> / (xfs)
>>
>> All works fine, no issues...
>>
>> Quick question though, I turned off the machine, disconnected /dev/sda
>> from the machine, boot from /dev/sdb, no problems, shows as degraded
>> RAID1.  Turn the machine off.  Re-attach the first drive.  When I boot
>> my first partition either re-synced by itself or it was not degraded,
>> was is this?
>
> If md0 was not touched (written to) after you disconnected sda, it also
> should not be in a degraded state.
>
>> So two questions:
>>
>> 1) If it rebuilt by itself, how come it only rebuilt /dev/md0?
>
> So md1/md2 was NOT rebuilt?
Correct.

>
>> 2) If it did not rebuild, is it because the kernel knows it does not
>>    need to re-calculate parity etc for swap?
>
> Kernel does not know what's inside an md usually. And it should not
> try to be smart.
Ok.

>
>> I had to:
>>
>> mdadm /dev/md1 -a /dev/sda2
>> and
>> mdadm /dev/md2 -a /dev/sda3
>>
>> To rebuild the /boot and /, which worked fine, I am just curious
>> though why it works like this, I figured it would be all or nothing.
>
> Devices are not automatically readded. Who knows, maybe you inserted a
> different disk into sda which you don't want to be overwritten.
Makes sense, I just wanted to confirm that it was normal..

>
>> More info:
>>
>> Not using ANY initramfs/initrd images, everything is compiled into 1
>> kernel image (makes things MUCH simpler and the expected device layout
>> etc is always the same, unlike initrd/etc).
>>
> My expected device layout is also always the same, _with_ initrd. Why?
> Simply because mdadm.conf is copied to the initrd, and mdadm will
> use your defined order.
>
That is another way as well, people seem to be divided.

