From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Help with two momentarily failed drives out of a 4x3TB Raid 5
Date: Mon, 11 Mar 2013 14:18:07 -0600
Message-ID: <62FAC682-2DDB-4912-97CF-3FACA3BD4B58@colorremedies.com>
References: <CAAnFQG9b1mUj+BJ3-_N-HjQi2w2Vv5pg4RCErXW5axp32_7T4g@mail.gmail.com> <CADNH=7Ed79h5GetY5XWOu=kKX=YNqVYmN1J6K25MVMwkH_Soyw@mail.gmail.com> <CAAnFQG_KdzFS6u+RrAfdL5gaOa-ozz9YAtb36oFo-ZofaLyxEw@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAnFQG_KdzFS6u+RrAfdL5gaOa-ozz9YAtb36oFo-ZofaLyxEw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Mar 10, 2013, at 6:33 PM, Javier Marcet <jmarcet@gmail.com> wrote:

> On Mon, Mar 11, 2013 at 1:12 AM, Mathias Bur=E9n <mathias.buren@gmail=
=2Ecom> wrote:
>>=20
>> So how are the drivers doing? smartctl -a for all HDDs please.
>=20
> http://bpaste.net/raw/82828/


Two of four drives report bad sectors as Current_Pending_Sector. We nee=
d to see full dmesg for the time when the array collapsed to be sure, b=
ut I bet dollars to donuts that disk 1 drops out for some reason (?) an=
d shortly thereafter the other drive experiences ERR UNC for its bad se=
ctor causing the array to collapse.

The first disk ejected is probably not in sync with the array and needs=
 to be rebuilt. The other drive might be slightly out of sync, but it's=
 worth forcing assemble to find out. And then these bad sectors need to=
 be repaired which is difficult if the first disk ejected happened befo=
re too many writes to the array while it was degraded but before the ar=
ray collapsed.

The drives clearly are configured incorrectly with their controller and=
/or the linux SCSI layer timeout for the block devices or you wouldn't =
have bad sectors pending. Configured correctly, bad sectors are remappe=
d in the course of a normally functioning array, as well as scheduled s=
crubs.

Ideally the drive SCT ERC is lowered to something like 70 deciseconds. =
Or if that's not supported by the drives, then the controller and the b=
lock device timeout needs to be raised to whatever the drive timeout is=
 using:

echo xxx >/sys/block/sdX/device/timeout

xxs is in seconds. So for a 2 minute drive timeout, you'd need that to =
be at least 120, maybe a few seconds more to make absolutely certain li=
nux doesn't timeout the block device before the drive itself reports a =
read error.


> By 18:00 today I should have the smartctl results.

Next to pointless in that it will stop the testing as soon as it finds =
the first bad sector. But if you have that LBA you can use dd to zero j=
ust that sector. While that corrupts the data in that sector, the data =
is effectively gone anyway, and it will prevent another read error and =
allow the rebuild to proceed.

> Could a faulty sata data cable cause those bad blocks?=20

No. Some bad sectors are normal. Many, or increasing occurrence is caus=
e for them to be replaced under warranty.

> How should I proceed to be able to get most of the data? Will I have
> to create a completely new array or can I somehow fix it adding new
> disks?

You're better off recreating the array and restoring from backup. Fixin=
g it will be tedious.


Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
