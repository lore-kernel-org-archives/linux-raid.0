From: David Brown <david.brown@hesbynett.no>
Subject: Re: Extendible RAID10
Date: Thu, 31 Mar 2011 21:10:30 +0200
Message-ID: <in2jj7$hn6$1@dough.gmane.org>
References: <imv5sm$tuj$1@dough.gmane.org> <20110331174230.GA10981@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110331174230.GA10981@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 31/03/11 19:42, Keld J=F8rn Simonsen wrote:
> On Wed, Mar 30, 2011 at 01:57:36PM +0200, David Brown wrote:
>> RAID10 with far layout is a very nice raid level - it gives you read
>> speed like RAID0, write speed no slower than other RAID1 mirrors, an=
d of
>> course you have the mirror redundancy.
>>
>> But it is not extendible - once you have made your layout, you are s=
tuck
>> with it.  There is no way (at the moment) to migrate over to larger =
drives.
>>
>> As far as I can see, you can grow RAID1 sets to larger disks.  But y=
ou
>> can't grow RAID0 sets.  As far as I can see, there is some inconsist=
ency
>> in the mdadm manual pages as to whether or not you can grow the size=
 of
>> a RAID4 array.  If it is possible to grow a RAID4, then it should be
>> possible to use a degraded RAID4 (with a missing parity disk) as a R=
AID0.
>>
>>
>> I'm planning a new server in the near future, and I think I'll get a
>> reasonable balance of price, performance, capacity and redundancy us=
ing
>> a 3-drive RAID10,f2 setup (with a small boot partition on each drive=
,
>> all three as a RAID1, so that grub will work properly).  On the main=
 md
>> device I then have an LVM physical volume, with logical partitions f=
or
>> different virtual machines or other data areas.  I've used such an
>> arrangement before, and been happy with it.
>>
>> But as an alternative solution that is expandable, I am considering
>> using LVM to do the striping.  Ignoring the boot partition for
>> simplicity, I would partition each disk into two equal parts - sda1,
>> sda2, sdb1, sdb2, sdc1 and sdc2.  Then I would form a set of RAID1
>> devices - md1 =3D sda1 + sdb2, md2 =3D sdb1 + sdc2, md3 =3D sdc1 + s=
da2.  I
>> would make an lvm physical volume on each of these md devices, and p=
ut
>> all those physical volumes into a single volume group.  Whenever I m=
ake
>> a new logical volume, I specify that it should have three stripes.
>>
>> If I then want to replace the disks with larger devices, it is possi=
ble
>> to add a new disk, partition it into two larger partitions, add thes=
e
>> partitions to two of the existing raids, sync, fail then remove the
>> now-redundant drive.  After three rounds, the RAID1 sets can then be
>> grown to match the new partition sizes.  Then the lvm physical volum=
es
>> can be grown to match the new raid sizes.
>>
>>
>> Any opinions?  Have I missed anything here, perhaps some issues that
>> will make this arrangement slower or less efficient than a normal
>> RAID10,f2 with lvm on top?
>
> I am not sure RAID10,f2 works well with LVM. I believe I have seen
> reports to the contrary.
>

I can't see any reason for that, but I'll try some googling for=20
references.  And at some point I will do some testing myself.  Thanks=20
for the warning.

> It should be possible to extend RAID10 arrays with more disks. I do n=
ot
> think it is so difficult. But I think neil does not have it on his wi=
sh
> list.
>

As far as I understand it, there is currently no way to extend RAID10 -=
=20
either by using larger partitions (such as after migrating to larger=20
disks) or by adding new disks.  It is possible to add new disks to a=20
RAID 1 array, and to grow the disks in a RAID 1 array, but there is no=20
resizing or reshaping of RAID 0 arrays at the moment.

I also thought that resizing and reshaping RAID10 arrays /was/ on Neil'=
s=20
wishlist, precisely because these are becoming a popular choice.


> best regards
> keld


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
