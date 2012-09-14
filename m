From: Chris Murphy <lists@colorremedies.com>
Subject: Re: raid1 issue after disk failure: both disks of the array are still active
Date: Fri, 14 Sep 2012 12:53:32 -0600
Message-ID: <7664099D-4C11-4254-B970-2DCAD5F86A46@colorremedies.com>
References: <5051AF17.8010501@linuxsystems.it> <20120913103432.GA11764@cthulhu.home.robinhill.me.uk> <B9AFB9BB-22CE-470D-AB47-E4CDA91C307B@colorremedies.com> <alpine.DEB.2.00.1209140912350.13902@uplift.swm.pp.se> <5052E096.5040509@linuxsystems.it> <45F26B36-1890-4F8E-BDF9-0DB49FDEE922@colorremedies.com> <20120914182755.GA2534@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120914182755.GA2534@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Sep 14, 2012, at 12:27 PM, Robin Hill wrote:

> On Fri Sep 14, 2012 at 12:04:56 -0600, Chris Murphy wrote:
>=20
>>=20
>> On Sep 14, 2012, at 1:45 AM, Niccol=F2 Belli wrote:
>>=20
>>> I also would like to know if the raid1 will *surely* use data from
>>> the other disk to write on the broken sector after a CHECK.
>>=20
>> Not according to documentation. In normal operation, and for a repai=
r,
>> what you describe is correct. But not for check.
>>=20
> Maybe you need to reread the documentation.

Probably. It's densely packed.

> So a check will repair cases where the data cannot be read at all, bu=
t
> will not repair cases where the data is returned but does not match t=
he
> data on the other mirror(s).

Yes, I now see the distinction between disk read-error and an array blo=
ck mismatch.

>=20
>>> I read that when raid1 is in doubt there is a 50%-50% chance it use=
s
>>> data from the good disk, wouldn't be better to fail the broken disk
>>> and then re-add it to the array?
>>=20
>> I don't know what this means.
>>=20
> I assume he's referring to cases where the data is read successfully =
but
> does not match the data on the mirror(s). In this case a repair will
> cause one copy to overwrite the others, which may or may not be the
> correct copy (md has no way of knowing for a mirrored pair).


I understand the ambiguity. It seems ill advised to arbitrarily replace=
 what could be valid data. So some clarification on what repair does in=
 a raid 1,10 block mismatch would be useful, as it may be repair should=
n't be used: rather use check and find out what file(s) are affected by=
 the mismatch and replace the files from backup.

This statement from documentation is confusing to me: "For RAID1/RAID10=
, all but one block are overwritten with the content of that one block.=
"

Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
