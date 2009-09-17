From: "Majed B." <majedb@gmail.com>
Subject: Re: Formatting Raid5 device as NTFS
Date: Fri, 18 Sep 2009 00:43:01 +0300
Message-ID: <70ed7c3e0909171443t68d81495y26acc8f5119d7aa3@mail.gmail.com>
References: <f5d1f90a0909171223h684e5f65k405fa319ab6be8d9@mail.gmail.com>
	<20090917200229.GA19611@cthulhu.home.robinhill.me.uk> <f5d1f90a0909171439x18555f61y8d6ab175c745473@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f5d1f90a0909171439x18555f61y8d6ab175c745473@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid Study <linuxraid.study@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

/dev/md0 is not mounted and it doesn't have a filesystem because you
didn't format the device after creating it.

After you have created the filesystem, run: mkfs.ntfs --fast /dev/md0

After that, you can mount it: mount /dev/md0 /mnt/windows

On Fri, Sep 18, 2009 at 12:39 AM, Linux Raid Study
<linuxraid.study@gmail.com> wrote:
> Hi Robin:
>
> I use mdadm cmd to create Raid5 device and did following:
>
> #mdadm --create /dev/md0 --level=3D5 --assume-clean --raid-devices=3D=
4
> /dev/sda /dev/sdb /dev/sdc /dev/sdd
>
> #mdadm -w /dev/md0
> mdadm: failed to set writable for /dev/md0: Device or resource busy
>
> ~ # mount
> none on /proc type proc (rw)
> none on /dev/shm type tmpfs (rw)
> none on /dev/pts type devpts (rw,mode=3D600)
> none on /sys type sysfs (rw)
> none on /mnth type hugetlbfs (rw)
>
> As u would notice, /dev/md0 is yet mounted...not sure why the above e=
rror....
>
> Thanks for ur help!
>
> On Thu, Sep 17, 2009 at 1:02 PM, Robin Hill <robin@robinhill.me.uk> w=
rote:
>> On Thu Sep 17, 2009 at 12:23:22PM -0700, Linux Raid Study wrote:
>>
>>> Hello:
>>>
>>> I have to bundle 4 disks as a Raid5 device, export it to iSCSI
>>> initiators and format it as NTFS.
>>>
>>> What is better:
>>> - Format individual disks as NTFS and then bundle them as Raid5 dev=
ice
>>> and export to initiator PCs
>>> - Or bundle the disks first as Raid5 dev, export them and then form=
at
>>> the /dev/md0 device as NTFS
>>>
>>> I get "write-protected" errors when I do the second option. Does it
>>> mean formatting of raid5 device is not allowed?
>>> Does Raid5 inherit the NTFS properties of individual disks (first o=
ption)?
>>>
>> I don't see your first option working at all. =C2=A0When you bundle =
the
>> drives together, the resulting device will have totally scrambled th=
e
>> underlying NTFS filesystems.
>>
>> The second option is how md RAID is supposed to work - you bundle
>> together the disks into a single array, then format that. =C2=A0Wher=
e are you
>> getting the "write-protected" errors? =C2=A0Are you trying to format=
 the
>> exported iSCSI device from a remote system? =C2=A0Certainly the RAID=
 device
>> can be formatted directly, but I've no idea how the iSCSI affects
>> things.
>>
>> HTH,
>> =C2=A0 =C2=A0Robin
>> --
>> =C2=A0 =C2=A0 ___
>> =C2=A0 =C2=A0( ' } =C2=A0 =C2=A0 | =C2=A0 =C2=A0 =C2=A0 Robin Hill =C2=
=A0 =C2=A0 =C2=A0 =C2=A0<robin@robinhill.me.uk> |
>> =C2=A0 / / ) =C2=A0 =C2=A0 =C2=A0| Little Jim says .... =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0|
>> =C2=A0// !! =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A0 =C2=A0"He fallen in=
 de water !!" =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 |
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
