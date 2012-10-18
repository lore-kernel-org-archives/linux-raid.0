From: Jivko Sabev <jsabev@nicmus.com>
Subject: Re: Cannot auto assemble a raid1 array on boot
Date: Thu, 18 Oct 2012 09:19:58 -0600
Message-ID: <CAG9W8wCH9bfHou72_+t+JoCS3EA96opcpTOTzkc2E0oFkbX8zg@mail.gmail.com>
References: <CAG9W8wBsh_i_jtqKFhEVywCk92hef41T0t+6J9saZD3CFT7V9A@mail.gmail.com>
	<507F7428.6030003@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <507F7428.6030003@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

The mdadm.conf in the initrd image contains the correct devices. I.e.
the contents of mdadm.conf in initrd are the output of

mdadm --detail --scan

ARRAY /dev/md0 metadata=1.2 name=mercury:0
UUID=60ea870e:029dcf99:eaae356e:f1c12085
ARRAY /dev/md1 metadata=1.2 name=mercury:1
UUID=d89a52ed:0247f2e8:5edf5d09:21e7fa48

However, the problem remains. That is when booting, the system dumps
into initramfs shell with the raid array in an inactive state. I have
to manually stop the array and then reassemble.

mdadm --manage --stop /dev/md1
mdadm --assemble /dev/md1 /dev/sde1 /dev/md0


At the point, I am able to continue booting and everything is fine after.

Here are the contents of /proc/mdstat from the initrd shell before
reassembling the array.

md1 : inactive sde1[2](S)
      976639672 blocks super 1.2

md0 : active linear sdb1[0] sdc1[1]
      976770537 blocks super 1.2 0k rounding

unused devices: <none>

It just seems to me that it is not possible to mix md devices and sata
devices for new arrays.

Regards,

Jivko

On Wed, Oct 17, 2012 at 9:14 PM, Adam Goryachev
<mailinglists@websitemanagers.com.au> wrote:
> On 18/10/12 13:35, Jivko Sabev wrote:
>> Greetings,
>>
>> I have a RAID1 array setup of the following
>>
>> /dev/md0 [linear raid array consisting of two 500GB SATA drives]
>> /dev/md1  [RAID1 array consisting of /dev/md0 and one 1TB SATA drive]
>>
>> here is my /proc/mdstat
>>
>> --------
>>
>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
>> [raid4] [raid10]
>> md1 : active raid1 md0[0] sde1[2]
>>       976639296 blocks super 1.2 [2/2] [UU]
>>
>> md0 : active linear sdb1[0] sdc1[1]
>>       976770537 blocks super 1.2 0k rounding
>>
>> unused devices: <none>
>>
>>
>> --------
>>
>> However, on every reboot, the md1 array is in degraded mode and I get
>> dumped to a intramfs shell. I can then assemble the said array - i.e.
>> mdadm --assemble /dev/md1 /dev/md0 /dev/sde1 and everything is fine.
>> Is it possible to have such an array auto assembled and how?
>>
>
> Maybe you need to update the mdadm.conf within the initrd image ?
>
> Regards,
> Adam
>
> --
> Adam Goryachev
> Website Managers
> www.websitemanagers.com.au
>
