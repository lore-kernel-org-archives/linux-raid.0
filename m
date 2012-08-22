From: Jan Ceuleers <jan.ceuleers@computer.org>
Subject: Re: Spares not added upon reboot after distro upgrade
Date: Wed, 22 Aug 2012 18:34:25 +0200
Message-ID: <50350A11.5030909@computer.org>
References: <50309900.9040108@computer.org> <5034C1CB.80808@computer.org> <503502FC.1080307@computer.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <503502FC.1080307@computer.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/22/2012 06:04 PM, Jan Ceuleers wrote:
> On 08/22/2012 01:26 PM, Jan Ceuleers wrote:
>> On 08/19/2012 09:42 AM, Jan Ceuleers wrote:
>> ...
>>
>>> For the first time ever I tried mdadm's incremental mode. So before
>>> issuing the above two commands I tried the following;
>>>
>>> root@zotac:~# mdadm -I /dev/sde2
>>> mdadm: failed to add /dev/sde2 to /dev/md0: Invalid argument.
>>
>> I have now straced this, and here are the offending lines:
>>
>> ioctl(4, 0x40140921, 0x7fff4bda3858)    = -1 EINVAL (Invalid argument)
>> write(2, "mdadm: failed to add /dev/sde2 t"..., 62mdadm: failed to add
>> /dev/sde2 to /dev/md0: Invalid argument.
>>
>> fd 4 is /dev/md0
>>
>> How does one decode the ioctl call?
> 
> Seems to be ADD_NEW_DISK(MD_MAJOR=md0, &mdu_disk_info_t)
> 
> I'm afraid I don't know how to interpret the last argument: is this a
> pointer or is it the contents of the struct (which should contain five
> ints, namely number, major, minor, raid_disks and state)?

The (minor, major) numbers of /dev/sde2 are (8, 66) or (0x08, 0x42).
Can't find those in the third ioctl argument.
