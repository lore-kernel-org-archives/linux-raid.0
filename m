From: Jivko Sabev <jsabev@nicmus.com>
Subject: Re: Cannot auto assemble a raid1 array on boot
Date: Thu, 25 Oct 2012 08:37:19 -0600
Message-ID: <CAG9W8wDVybKYr8VRp2bpxOOPHGnGw3ny1xUjVGsiNi3wya2tuw@mail.gmail.com>
References: <CAG9W8wBsh_i_jtqKFhEVywCk92hef41T0t+6J9saZD3CFT7V9A@mail.gmail.com>
	<507F7428.6030003@websitemanagers.com.au>
	<CAG9W8wCH9bfHou72_+t+JoCS3EA96opcpTOTzkc2E0oFkbX8zg@mail.gmail.com>
	<20121024123330.3084e7b3@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121024123330.3084e7b3@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Adam Goryachev <mailinglists@websitemanagers.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Thanks for the insightful information. I am running ubuntu 12.04.1 LTS
(desktop version). As per your suggestion, I have run

mdadm -I /dev/md0

from the initramfs and indeed /dev/md1 gets assembled.

Your suggestions have definitely started me on the right path. I have
done some further googling and apparently the problem I am
experiencing is somewhat common in 12.04. I am in the process of
modifying some of the init scripts to make my array assemble
correctly. I have tried the workaround described here

http://utcc.utoronto.ca/~cks/space/blog/linux/Ubuntu1204SoftwareRaidFail

but it did not solve the problem for me.

I will post my solution once it is done.

Regards,

Jivko


Re



On Tue, Oct 23, 2012 at 7:33 PM, NeilBrown <neilb@suse.de> wrote:
> On Thu, 18 Oct 2012 09:19:58 -0600 Jivko Sabev <jsabev@nicmus.com> wrote:
>
>> Hi,
>>
>> The mdadm.conf in the initrd image contains the correct devices. I.e.
>> the contents of mdadm.conf in initrd are the output of
>>
>> mdadm --detail --scan
>>
>> ARRAY /dev/md0 metadata=1.2 name=mercury:0
>> UUID=60ea870e:029dcf99:eaae356e:f1c12085
>> ARRAY /dev/md1 metadata=1.2 name=mercury:1
>> UUID=d89a52ed:0247f2e8:5edf5d09:21e7fa48
>>
>> However, the problem remains. That is when booting, the system dumps
>> into initramfs shell with the raid array in an inactive state. I have
>> to manually stop the array and then reassemble.
>>
>> mdadm --manage --stop /dev/md1
>> mdadm --assemble /dev/md1 /dev/sde1 /dev/md0
>>
>>
>> At the point, I am able to continue booting and everything is fine after.
>>
>> Here are the contents of /proc/mdstat from the initrd shell before
>> reassembling the array.
>>
>> md1 : inactive sde1[2](S)
>>       976639672 blocks super 1.2
>>
>> md0 : active linear sdb1[0] sdc1[1]
>>       976770537 blocks super 1.2 0k rounding
>
> There are two problems here.
>
> Firstly, the fact that the array doesn't assemble completely should not cause
> the boot to fail.  A degraded raid1 is perfectly sufficient for booting.
>
> What is happening is that the initrd is relying on udev to assemble the array
> by passing each new device to "mdadm --incremental $DEVNAME".
> This will assemble the array as soon as all devices are present, but not
> before.   If a device failed before shutdown that will be recorded in the
> metadata and "mdadm --incremental" will not wait for it.  If it disappears
> during reboot, mdadm will still expect it.
>
> To deal with this issue, the initrd should run
>   mdadm --incremental --scan --run
>
> which means "look for all arrays that are being incrementally assembled, and
> start them".
> This should be called after running "udevadm settle" and before mounting the
> root filesystem.
>
> However fixing this won't fix your problem, it will just change it.
>
> The udev rules files which is calling "mdadm --incremental" does so
> on /dev/sdb1 /dev/sdc1 and /dev/sde1, but apparently not on /dev/md0.
>
> If at the initrd shell prompt you run
>   mdadm -I /dev/md0
>
> it should finish assembling md1 for you.  For some reason udev isn't doing
> that.
>
> Have a look in /lib/udev/rules.d or /etc/udev/rules.d for a file that runs
> "mdadm --incremental" or "mdadm -I" and see how it works.
> Maybe post it.
>
> BTW what distro are you using?
>
> NeilBrown
>
