From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: grub2/grub-pc install not possible on mdadm
Date: Mon, 05 Mar 2012 12:34:23 +0000
Message-ID: <4F54B2CF.90705@anonymous.org.uk>
References: <4F4C9A11.9060302@profihost.ag> <4F4F4B1D.4050000@redhat.com> <4F4F4EB3.6030909@profihost.ag> <4F4F519E.7040206@redhat.com> <4F508864.4050600@profihost.ag> <20120302100648.fe4e725f2e98880c839357b0@bbaw.de> <4F508EB6.2030101@profihost.ag> <4F5091BF.1000102@anonymous.org.uk> <4F509402.8070503@profihost.ag> <4F50ABA3.1070603@anonymous.org.uk> <4F50C7DC.3000700@profihost.ag> <20120302163236.3555fec1296cbe30d8d37972@bbaw.de> <4F547038.7060009@profihost.ag> <4F54899A.4040301@anonymous.org.uk> <20120305111402.e63fee5b49046ed146cb9dcc@bbaw.de> <4F54A42A.4020903@anonymous.org.uk> <20120305123806.ee01dd22b03c393314af12c9@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120305123806.ee01dd22b03c393314af12c9@bbaw.de>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Lars_T=E4uber?= <taeuber@bbaw.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/03/2012 11:38, Lars T=E4uber wrote:
> Am Mon, 05 Mar 2012 11:31:54 +0000
> John Robinson<john.robinson@anonymous.org.uk>  schrieb:
>>> You mean if Stefan would have used an old fashioned partition table
>>> inside a Linux SW-RAID with metadata 1.2, grub would have booted li=
ke
>>> normal?
>>
>> Yes, both grub2 and grub legacy (0.97) read partition tables. Only g=
rub2
>> can really read inside RAID arrays - any metadata, any RAID level - =
[...]
>
> Does grub2 also read partitions inside SW-RAID if the RAID consists o=
f
> partitions?
> How deep works this mechanism?
>
> DISK =3D>  partitions =3D>  RAID =3D>  partition table =3D>  RAID =3D=
>  ....

I don't know. I'm sure DISK =3D> partitions =3D> RAID =3D> partitions w=
ill=20
work - that's what I was suggesting Stefan should do to use 1.2=20
metadata. You can have LVM in the mix too. Oh and don't forget the=20
filesystem right at the end. It may be possible to get it to support=20
multi-level RAID but I haven't tried - I try to keep it simple with DIS=
K=20
=3D> partition =3D> RAID-1 =3D> ext2; it's enough bother getting all th=
e other=20
mess taken care of in the initrd and Linux, without doing it in GRUB to=
o!

Cheers,

John.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
