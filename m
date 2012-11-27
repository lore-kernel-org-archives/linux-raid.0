From: Kks Kbase <kks.kbase@yahoo.in>
Subject: Re: Know about chunk size
Date: Tue, 27 Nov 2012 15:39:17 +0800 (SGT)
Message-ID: <1354001957.48019.YahooMailNeo@web190602.mail.sg3.yahoo.com>
References: <186704.2.1353915309639.JavaMail.root@zimbra> <50B3E916.90205@hardwarefreak.com>
Reply-To: Kks Kbase <kks.kbase@yahoo.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50B3E916.90205@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: "stan@hardwarefreak.com" <stan@hardwarefreak.com>, Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Okay thanks.

If we deleted the raid device and created new one with the disks that h=
ave data would it cause the data loss?



----- Original Message -----
=46rom: Stan Hoeppner <stan@hardwarefreak.com>
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Kks Kbase <kks.kbase@yahoo.in>; Linux Raid <linux-raid@vger.kernel.=
org>
Sent: Tuesday, 27 November 2012 3:41 AM
Subject: Re: Know about chunk size

On 11/26/2012 1:35 AM, Roy Sigurd Karlsbakk wrote:
>> I want to know what is best chunk size to create s/w raid devices?
>=20
> That depends on the workload, file sizes etc.=20

Correct.=A0 And greatly depends on array type.

> The default will probably do fine

This is not true of metadata 1.2 and parity arrays in which case the
default chunk size is 512KB.=A0 That's way too large for anything but
large file streaming workloads.=A0 Most workloads involve metadata and
small files.=A0 This has been discussed previously in detail on this li=
st
and on the XFS list.=A0 For most workloads other than large file
streaming, mirroring+striping is best, but if you must use parity RAID =
a
small chunk size of 32/64KB yields superior IO performance due to
decreased overhead during RMW.

>> Also is it possible to change the chunk size for an existing array?

No.=A0 You must destroy and recreate it with the new chunk size.=A0 If =
one
creates an array with an appropriate chunk size there is no need to eve=
r
change it, UNLESS the primary workload hitting the array changes from
random IO to large streaming, or the reverse.=A0 In such a case one
typically builds a new server with a new array, or simply adds a new
array to the existing server for the new workload.=A0 If you are
redeploying the server/array, destroy and recreate with the new optimal
chunk size.

--=20
Stan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
