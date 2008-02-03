From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: RAID 1 and grub
Date: Sun, 03 Feb 2008 16:50:25 +1300
Message-ID: <47A53A01.9030809@sauce.co.nz>
References: <47A0F4DC.9030005@sauce.co.nz> <72dbd3150801301641n2801846cgc2f3bc04aa842baf@mail.gmail.com> <47A13379.50703@sauce.co.nz> <72dbd3150801301847s6bbfa958h1213e782627e64a1@mail.gmail.com> <20080202235128.GB24990@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080202235128.GB24990@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Keld J=F8rn Simonsen wrote:

>> # grub
>> grub> device (hd0) /dev/hdc
>> grub> root (hd0,0)
>> grub> setup (hd0)
>=20
> I do not grasp this. How and where is it said that two disks are
> involved? hda and hdc should both be involved.

There are not two disks involved in this instance.

This is used in the scenario where the primary disk in the RAID1=20
(/dev/hda), already has grub installed in the MBR and you wish to=20
install it on the secondary drive (/dev/hdc).

This then allows for a failed primary drive to be removed and the=20
machine to boot from the secondary - (may need BIOS to be set to boot=20
from secondary drive).

As an aside, after last weeks discovery that the Fedora 8 install had=20
not installed grub on the secondary drive, as part of a RAID 1 install,=
=20
some cursory Googling and searching Redhat's Knowledge base leads me to=
=20
believe that this may well be normal for all Redhat (RHEL/Fedora) RAID1=
=20
installs.

One has nothing to lose by installing grub on the second drive in this=20
case and it may save some delay in recovery on losing the primary,=20
although as has been pointed out, it is best practice to test missing=20
drives as part of initial install testing.

Regards,

Richard
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
