From: Erwan Leroux <erwan.lerou@gmail.com>
Subject: Re: standard performance (write speed ??Mb/s) - new raid5 array
Date: Fri, 22 Jul 2011 10:13:02 +0200
Message-ID: <CAHX8RiSDcpvgictvbbSmSgpkpKLpz=Pj4uuXp-Cr4Rg_DW0ugA@mail.gmail.com>
References: <201107162140.58883.raid1@fuckaround.org> <201107211907.36864.raid1@fuckaround.org>
 <4E28BEC3.4000301@hardwarefreak.com> <201107220908.28819.raid1@fuckaround.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201107220908.28819.raid1@fuckaround.org>
Sender: linux-raid-owner@vger.kernel.org
To: polhallen@fuckaround.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I never used the whole disk in my raid, so maybe my procedure is not
useful in this case,
but i think if you create partitions, you should create the array using=
 them,
using the following command mdadm --create --verbose /dev/md0
--level=3Draid5 --raid-devices=3D5 /dev/sd[bcdef]1 --metadata 1.2
i can't recall where i see why to specify this metadata level but in
my case the default was not 1.2 so i had to.

When the rebuild is done and a filesystem set , run this command dd
if=3D/dev/zero of=3D/some/dir/test.dd bs=3D4096 count=3D2621440
to actually test the performance of the raid.

2011/7/22 Pol Hallen <raid1@fuckaround.org>:
>> Why did you create partitions? =A0The whole point of zeroing the fir=
st 512
>> bytes was to *eliminate* all the partitions...
>
> Follow the post of Erwan Leroux, he advise creare a new partition wit=
h non-fs
> data :-/
>
>> No, you did not. =A0It seems you merged bits and pieces from each ar=
ray
>> creation method. =A0The array may still function properly. =A0I've n=
ever
>> tried what you've done here. =A0Maybe others have the correct answer=
=2E
>
> I wish it's everything ok :-)
>
> Pol
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
