From: Miquel van Smoorenburg <mikevs@xs4all.net>
Subject: Re: replaced disk in RAID1 imsm array - how to activate?
Date: Thu, 09 Aug 2012 19:56:22 +0200
Message-ID: <5023F9C6.60706@xs4all.net>
References: <20120809134201.GA14931@xs4all.net> <CABYL=ToJNYJhOH9jx8Dc-AynVGEMou4tx+echx7H6SGKeabELg@mail.gmail.com> <5023C686.7020704@xs4all.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5023C686.7020704@xs4all.net>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Aha! Found it!

Before I tried IMSM support on real hardware, I ran some tests in=20
VirtualBox. Because VirtualBox has no Intel Matrix option rom, I set=20
IMSM_NO_PLATFORM=3D1 everywhere.

That was stil the case in my initramfs, so mdmon was started with=20
IMSM_NO_PLATFORM=3D1 in the environment. And apparently everything just=
=20
works, except for adding a fresh disk as a spare ..

I restarted (-t --all) mdmon without IMSM_NO_PLATFORM in the=20
environment, did mdmon /dev/md127 --add /dev/sda, and the rebuild=20
started right away.

Thanks,

Mike.

On 9-08-12 4:17 PM, Miquel van Smoorenburg wrote:
>
> (oh apologies- I misspelt imsm as imsi in the subject - really mean
> imsm, the Intel Matrix BIOS fakeraid).
>
> This server has two disks, /dev/sda and /dev/sdb. I created a RAID1 I=
MSM
> array in the BIOS, then booted linux and detected the array with
>
> mdadm --examine --scan > /etc/mdadm/mdadm.conf
> mdadm --assemble --scan --run --auto=3Dyes
>
> Then /dev/md127 shows up as imsm container, /dev/md126 is the array
> itself, and (after partitioning) /dev/md looks like this:
>
> root@server3-b05-tpb:~# ls -l /dev/md
> total 0
> lrwxrwxrwx 1 root root  8 Aug  9 14:15 Volume0 -> ../md126
> lrwxrwxrwx 1 root root 10 Aug  9 13:34 Volume0p1 -> ../md126p1
> lrwxrwxrwx 1 root root 10 Aug  9 13:34 Volume0p2 -> ../md126p2
> lrwxrwxrwx 1 root root 10 Aug  9 13:34 Volume0p5 -> ../md126p5
> lrwxrwxrwx 1 root root  8 Aug  9 13:55 imsm0 -> ../md127
>
> Then I removed /dev/sda (by pulling it out), put it back in, zero'd t=
he
> superblock, added it back with mdadm --add /dev/md127 /dev/sda, and n=
ow
> it just sits there as member of the container, but the array in md126
> doesn't start to rebuild.
>
> [ actually, it's a bit more complicated than this, since I am fixing =
up
> the debian wheezy installer to support imsm arrays, with quite a bit =
of
> success, so I installed debian with this array as the root filesystem=
 ]
>
> Yes, mdmon is running.
>
> dmesg when I pulled out /dev/sda:
>
> ata1: exception Emask 0x50 SAct 0x0 SErr 0x4090800 action 0xe frozen
> ata1: irq_stat 0x00400040, connection status changed
> ata1: SError: { HostInt PHYRdyChg 10B8B DevExch }
> ata1: hard resetting link
> ata1: SATA link down (SStatus 0 SControl 300)
> ata1: hard resetting link
> ata1: SATA link down (SStatus 0 SControl 300)
> ata1: limiting SATA link speed to 1.5 Gbps
> ata1: hard resetting link
> ata1: SATA link down (SStatus 0 SControl 310)
> ata1.00: disabled
> ata1: EH complete
> sd 1:0:0:0: rejecting I/O to offline device
> killing request
> Unhandled error code
>   Result: hostbyte=3DDID_NO_CONNECT driverbyte=3DDRIVER_OK
> CDB: Write(10): 2a 00 57 54 66 ef 00 00 01 00
> end_request: I/O error, dev sda, sector 1465149167
> ata1.00: detaching (SCSI 1:0:0:0)
> Synchronizing SCSI cache
>   Result: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
> Stopping disk
> START_STOP FAILED
>   Result: hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
> md/raid1:md126: Disk failure on sda, disabling device.
> md/raid1:md126: Operation continuing on 1 devices.
> RAID1 conf printout:
>   --- wd:1 rd:2
>   disk 0, wo:1, o:0, dev:sda
>   disk 1, wo:0, o:1, dev:sdb
> RAID1 conf printout:
>   --- wd:1 rd:2
>   disk 1, wo:0, o:1, dev:sdb
> md: unbind<sda>
> md: export_rdev(sda)
>
>
>
> On 08/09/2012 03:47 PM, Roberto Spadim wrote:
>> explain better..
>> do you have 2 disks in raid1, and removed one disk, or removed two d=
isks?
>> could you send dmesg messages?
>>
>> 2012/8/9 Miquel van Smoorenburg <mikevs@xs4all.net>:
>>> Setup: kernel 3.2.21 (debian testing), mdadm 3.2.5.
>>>
>>> I created a RAID1 imsi array on a supermicro server for testing
>>> purposes. I'm trying to see what happens if I hot-remove disks,
>>> hot-add them, reboot, etc to test the resiliency of this setup.
>>>
>>> So I removed (by pulling it out) one disk, then simulated adding
>>> a blank replacement disk by putting it back in and running
>>> mdadm --zero-superblock on it.
>>>
>>> I re-added it to the container with mdadm /dev/md127 --add /dev/sda=
=2E.
>>> and now it just sits there. How do I get the RAID1 array (dev/md126=
)
>>> to start using this disk? The manpage says:
>>>
>>>         -a, --add
>>>                hot-add  listed  devices.  If a device appears to ha=
ve
>>> recently
>>>                been part of the array (possibly it failed or was
>>> removed)  the
>>>                device  is  re-added  as  described in the next
>>> point.  If that
>>>                fails or the device was never part of the array, the
>>> device  is
>>>                added  as a hot-spare.  If the array is degraded, it
>>> will imme=E2=80=90
>>>                diately start to rebuild data onto that spare.
>>>
>>> However, nothing is happening:
>>>
>>> root@server3-b05-tpb:~/tmp# cat /proc/mdstat
>>> Personalities : [raid1]
>>> md126 : active raid1 sdb[0]
>>>        31457280 blocks super external:/md127/0 [2/1] [_U]
>>>
>>> md127 : inactive sda[1](S) sdb[0](S)
>>>        6306 blocks super external:imsm
>>>
>>>
>>> Thanks,
>>>
>>> Mike.
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
