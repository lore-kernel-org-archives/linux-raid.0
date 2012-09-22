From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: GPT Table broken on a Raid1
Date: Sat, 22 Sep 2012 23:07:06 +0100
Message-ID: <505E368A.4020200@anonymous.org.uk>
References: <4961154.0TR9MeFlIq@techz> <2627519.Y2VdWh5VBI@techz> <1BDFB79A-E375-47F2-8EDF-8F51D8774651@colorremedies.com> <1361158.MkTZ6QR6cp@techz> <E9C051A7-65EB-48F5-8D3B-1C374F271E0C@colorremedies.com> <3EC7177F-9973-4D2E-988B-7020298E1727@colorremedies.com> <505DD9E2.7090908@anonymous.org.uk> <F7E53090-1143-4811-86B9-E71923B98AA2@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F7E53090-1143-4811-86B9-E71923B98AA2@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 22/09/2012 19:45, Chris Murphy wrote:
> On Sep 22, 2012, at 9:31 AM, John Robinson wrote:
>> I don't think there's anything wrong here.
>>
>> The kernel sees the whole discs, sda and sdb, and complains that the=
 GPT partition table looks wrong becase the second copy isn't at the en=
d of the discs. That's correct, at the end of the raw discs is the IMSM=
 metadata.
>
> OK so sda and sdb shouldn't have been partitioned in the first place,=
 is what that tells me.

That's not what I'm saying. I'm saying that sda and sdb weren't=20
partitioned in the first place. I'm saying that when the Linux kernel=20
boots, and the AHCI driver starts, it sees the IMSM member discs as raw=
=20
discs, which get probed for partitions. The GPT partition probe spots=20
one of the copies of the GPT partition, but can't find the other one=20
because the IMSM metadata's there. Then later on, md starts, reads the=20
IMSM metadata, and presents the RAID set, including the GPT partition=20
table that the raw-disc probe already whinged about, but which in the=20
RAID set is correct.

The error messages that G=FCnther saw are a false positive and harmless=
 -=20
or at least, harmless until someone starts telling him to go messing=20
around rewriting the contents of the raw drives underneath md by=20
deleting the misidentified partition tables, the effect of which is=20
likely to be to damage his partitions inside the IMSM array and/or=20
destroy the IMSM array metadata.

>> Don't try to change the partition tables on /dev/sda and sdb or you =
will damage the IMSM metadata.
>
> Sounds like either imsm metadata is either not well designed for GPT

I think I'd describe it was being designed so that individual discs fro=
m=20
RAID-1 mirrors can be read independently.

IMSM predates GPT anyway.

> or it was intended to be placed on an unpartitioned disk in the first=
 place.

It can't be anything else.

Cheers,

John.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
