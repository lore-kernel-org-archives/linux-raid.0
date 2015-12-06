From: David Waite <david@alkaline-solutions.com>
Subject: Re: Unable to (un)-grow raid6
Date: Sun, 6 Dec 2015 14:13:22 -0700
Message-ID: <9F08EE4D-B926-4F8F-9F9D-F9C7234959B4@alkaline-solutions.com>
References: <4E26C335-DEDB-489E-B54E-A285273569A1@alkaline-solutions.com> <465BF0F5-B5C7-4C02-8EB5-552B959B8D29@alkaline-solutions.com> <56649C04.9000601@turmel.org>
Mime-Version: 1.0 (Mac OS X Mail 9.1 \(3096.5\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56649C04.9000601@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> On Dec 6, 2015, at 1:35 PM, Phil Turmel <philip@turmel.org> wrote:
>=20
> On 12/05/2015 10:04 PM, David Waite wrote:
>> I=E2=80=99m having difficulty shrinking down a RAID6 array (md2) on =
a Sinology NAS. I wish to go from 13 drives to 11, and believe I need t=
o go to 12 first to maintain operation and redundancy through the resiz=
ing process.
>=20
> No, you can go straight to 11 if you've set array-size properly.  --g=
row
> operations maintain redundancy throughout.

I thought =E2=80=94grow maintains redundancy for power loss but not dis=
k failure.

Would I do this by simply marking the other drive I want to remove as f=
ailed?

I=E2=80=99ll try =E2=80=94array-size again. How is the array-size sugge=
stion by mdadm calculated - the drives are not of uniform size.

-DW--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
