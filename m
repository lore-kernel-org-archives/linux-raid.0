From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: new raid system for home use
Date: Mon, 19 Apr 2004 12:20:02 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4083FC32.7050103@pobox.com>
References: <Pine.LNX.4.44.0404181411130.21013-100000@coffee.psychology.mcmaster.ca> <Pine.LNX.4.58.0404181253470.24065@spoon.loc> <4083F865.7070803@chemie.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4083F865.7070803@chemie.uni-erlangen.de>
To: schmidt@naa.net
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Norman Schmidt wrote:
> Hi Paul!
>=20
> Paul Phillips schrieb:
>=20
>> I was under the impression that I can't boot off raid-5, but if that
>> information is dated then all the better.
>>
>> Thanks again.
>=20
>=20
> Afaik, that=B4s still true. The reason is that the two (or more) driv=
es of=20
> a raid 1 essentially hold the same data, and if you do everything rig=
ht,=20
> the complete boot mechanism is on all disks, so that you can boot wit=
h=20
> any of them. On raid 5 disks, you would never have the complete data =
on=20
> any of the disks.


If you can load an initrd, you can boot off of anything.

The question then becomes whether or not you can load the initrd :)=20
Sometimes even in RAID5 situations you can...

	Jeff



-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
