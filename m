From: Simon Valiquette <v.simon@ieee.org>
Subject: Re: RAID 5 Grow
Date: Fri, 15 Jul 2005 16:16:01 -0400
Message-ID: <42D81981.1050902@ieee.org>
References: <1121457052.3012.36.camel@x1-6-00-0d-60-fd-e8-4c>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1121457052.3012.36.camel@x1-6-00-0d-60-fd-e8-4c>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

=46orrest Taylor a =E9crit :
> I am doing some RAID scenarios on a single disc (testing purposes) on
> RHEL4.  I have some partitions as follows:
>=20
> /dev/hda5  100M
> /dev/hda6  200M
> /dev/hda7  200M
> /dev/hda8  200M
> /dev/hda9  200M
>=20
> I create a RAID 5 set with /dev/hda{5,6,7,8}.  I fail/remove /dev/hda=
5
> and add /dev/hda9, at which point I can grow the RAID.  Running:
>=20
> mdadm -G /dev/md0 -z max
>=20

   Have you copied the data from hda5 to hda9 with dd?  If i remember,=20
growing a RAID 5 that way is done by creating the missing stripes at=20
the end of each disks.  If the array is already in degraded mode, I am=20
not sure if mdadm is able to recover from that.

Simon
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
