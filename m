From: Phil Turmel <philip@turmel.org>
Subject: Re: Unable to (un)-grow raid6
Date: Sun, 6 Dec 2015 16:21:38 -0500
Message-ID: <5664A6E2.4070900@turmel.org>
References: <4E26C335-DEDB-489E-B54E-A285273569A1@alkaline-solutions.com>
 <465BF0F5-B5C7-4C02-8EB5-552B959B8D29@alkaline-solutions.com>
 <56649C04.9000601@turmel.org>
 <9F08EE4D-B926-4F8F-9F9D-F9C7234959B4@alkaline-solutions.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9F08EE4D-B926-4F8F-9F9D-F9C7234959B4@alkaline-solutions.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Waite <david@alkaline-solutions.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/06/2015 04:13 PM, David Waite wrote:
>=20
>> On Dec 6, 2015, at 1:35 PM, Phil Turmel <philip@turmel.org> wrote:
>>
>> On 12/05/2015 10:04 PM, David Waite wrote:
>>> I=E2=80=99m having difficulty shrinking down a RAID6 array (md2) on=
 a Sinology NAS. I wish to go from 13 drives to 11, and believe I need =
to go to 12 first to maintain operation and redundancy through the resi=
zing process.
>>
>> No, you can go straight to 11 if you've set array-size properly.  --=
grow
>> operations maintain redundancy throughout.
>=20
> I thought =E2=80=94grow maintains redundancy for power loss but not d=
isk failure.
>=20
> Would I do this by simply marking the other drive I want to remove as=
 failed?

No!  Is that what you did with the other one?

--grow with a reduction in number leaves the unneeded drive(s) as hot
spares when it is complete.  That's when you remove them.  Or, if it
didn't pick the drives you wanted to remove, you can then do a --replac=
e
operation, which also maintains redundancy throughout.

> I=E2=80=99ll try =E2=80=94array-size again. How is the array-size sug=
gestion by mdadm calculated - the drives are not of uniform size.

You didn't post your --detail and --examine output as requested, so I
can't be specific.  For parity arrays, the size of the smallest member
controls the size of the array.

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
