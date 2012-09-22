From: Chris Murphy <lists@colorremedies.com>
Subject: Re: GPT Table broken on a Raid1
Date: Sat, 22 Sep 2012 16:30:28 -0600
Message-ID: <6FBE5434-A133-43C0-8296-58978301D32B@colorremedies.com>
References: <4961154.0TR9MeFlIq@techz> <2627519.Y2VdWh5VBI@techz> <1BDFB79A-E375-47F2-8EDF-8F51D8774651@colorremedies.com> <1361158.MkTZ6QR6cp@techz> <E9C051A7-65EB-48F5-8D3B-1C374F271E0C@colorremedies.com> <3EC7177F-9973-4D2E-988B-7020298E1727@colorremedies.com> <505DD9E2.7090908@anonymous.org.uk> <F7E53090-1143-4811-86B9-E71923B98AA2@colorremedies.com> <505E368A.4020200@anonymous.org.uk>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <505E368A.4020200@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Sep 22, 2012, at 4:07 PM, John Robinson wrote:

> On 22/09/2012 19:45, Chris Murphy wrote:
>> On Sep 22, 2012, at 9:31 AM, John Robinson wrote:
>>> I don't think there's anything wrong here.
>>>=20
>>> The kernel sees the whole discs, sda and sdb, and complains that th=
e GPT partition table looks wrong becase the second copy isn't at the e=
nd of the discs. That's correct, at the end of the raw discs is the IMS=
M metadata.
>>=20
>> OK so sda and sdb shouldn't have been partitioned in the first place=
, is what that tells me.
>=20
> That's not what I'm saying. I'm saying that sda and sdb weren't parti=
tioned in the first place.

I disagree, it appears they were partitioned, but we'll see when the OP=
 posts back the results from gdisk. The kernel messages in the very fir=
st post seems to imply it was partitioned (at least, at one time) or th=
ere wouldn't be an sdb1, sdb2, sdb3, etc.

=46rom the first post:
> Sep 17 09:54:27 techz kernel: [    1.204710]  sdb: sdb1 sdb2 sdb3 sdb=
4 sdb5=20
> sdb6

> I'm saying that when the Linux kernel boots, and the AHCI driver star=
ts, it sees the IMSM member discs as raw discs, which get probed for pa=
rtitions. The GPT partition probe spots one of the copies of the GPT pa=
rtition, but can't find the other one because the IMSM metadata's there=
=2E

The IMSM metadata will go at the end of the PHYSICAL disk. If you parti=
tion the virtual disk, i.e. the array, /dev/md/imsm0, then the GPT alte=
rnate header goes at the end of the virtual disk, NOT the end of the ph=
ysical disk.

Besides, if what you say is true, as soon as he GPT partitioned the arr=
ay, if the secondary GPT header stepped on IMSM metadata, then the arra=
y would instantly break. That's not what happened.=20

>=20
>=20
> The error messages that G=FCnther saw are a false positive and harmle=
ss

I think so too, but are the result of the raw disks being previously pa=
rtitioned. Possibly even they are stale GPTs that should have been nuke=
d before getting started with IMSM RAID.

> - or at least, harmless until someone starts telling him to go messin=
g around rewriting the contents of the raw drives underneath md by dele=
ting the misidentified partition tables, the effect of which is likely =
to be to damage his partitions inside the IMSM array and/or destroy the=
 IMSM array metadata.

There's every reason to believe the primary GPT header on /dev/sda and =
/dev/sdb is a.) intact and b.) is in LBA 1 and c.) Cannot also include =
IMSM metadata. So removing that header would thus make obliterate the G=
PT on the physical disks and he'd stop getting the error message. If he=
's really bothered by what is in effect a harmless error message becaus=
e that (stale) GPT doesn't matter anyway.

Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
