From: =?ISO-8859-15?Q?Tor_Arne_Vestb=F8?= <torarnv@gmail.com>
Subject: Re: Creating RAID5 with four devices and end up with 5 (one removed and one spare). Why?
Date: Mon, 3 Mar 2008 11:01:41 +0100
Message-ID: <47CBCC85.5000207@gmail.com>
References: <47CBBD11.4020501@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fqghv3$82v$1@ger.gmane.org>
References: <47CBC516.5050904@gmail.com>
References: <fqghv3$82v$1@ger.gmane.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mario 'BitKoenig' Holbe wrote:
> Tor Arne Vestb=F8 <torarnv@gmail.com> wrote:
>> But does that explain why mdadm believes I have another disk, a fift=
h=20
>> disk, that has been removed? The ID numbers of the real disks are=20
>> 0,1,2,4 but I would expect 0,1,2,3:
>=20
> Once the rebuild has finished, you will have exactly the latter.
> md stores raid-disks in different slots than not-yet-raid-disks.

I see :) Thank you both!

Tor Arne
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
