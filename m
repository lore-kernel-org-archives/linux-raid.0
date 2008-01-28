From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: striping of a 4 drive raid10
Date: Mon, 28 Jan 2008 13:24:45 -0500
Message-ID: <479E1DED.4010907@tmr.com>
References: <20080127193345.GA5426@rap.rap.dk> <18332.58858.191866.347099@notabene.brown> <20080127204841.GA10112@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080127204841.GA10112@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=F8rn Simonsen wrote:
> On Mon, Jan 28, 2008 at 07:13:30AM +1100, Neil Brown wrote:
>  =20
>> On Sunday January 27, keld@dkuug.dk wrote:
>>    =20
>>> Hi
>>>
>>> I have tried to make a striping raid out of my new 4 x 1 TB
>>> SATA-2 disks. I tried raid10,f2 in several ways:
>>>
>>> 1: md0 =3D raid10,f2 of sda1+sdb1, md1=3D raid10,f2 of sdc1+sdd1, m=
d2 =3D raid0
>>> of md0+md1
>>>
>>> 2: md0 =3D raid0 of sda1+sdb1, md1=3D raid0 of sdc1+sdd1, md2 =3D r=
aid01,f2
>>> of md0+md1
>>>
>>> 3: md0 =3D raid10,f2 of sda1+sdb1, md1=3D raid10,f2 of sdc1+sdd1, c=
hunksize of=20
>>> md0 =3Dmd1 =3D128 KB,  md2 =3D raid0 of md0+md1 chunksize =3D 256 K=
B
>>>
>>> 4: md0 =3D raid0 of sda1+sdb1, md1=3D raid0 of sdc1+sdd1, chunksize
>>> of md0 =3D md1 =3D 128 KB, md2 =3D raid01,f2 of md0+md1 chunksize =3D=
 256 KB
>>>
>>> 5: md0=3D raid10,f4 of sda1+sdb1+sdc1+sdd1
>>>      =20
>> Try
>>   6: md0 =3D raid10,f2 of sda1+sdb1+sdc1+sdd1
>>    =20
>
> That I already tried, (and I wrongly stated that I used f4 in stead o=
f
> f2). I had two times a thruput of about 300 MB/s but since then I cou=
ld
> not reproduce the behaviour. Are there errors on this that has been
> corrected in newer kernels?
>
>
>  =20
>> Also try raid10,o2 with a largeish chunksize (256KB is probably big
>> enough).
>>    =20
>
> I tried that too, but my mdadm did not allow me to use the o flag.
>
> My kernel is 2.6.12  and mdadm is v1.12.0 - 14 June 2005.
> can I upgrade the mdadm alone to a newer version, and then which is
> recommendable?
>  =20

I doubt that updating the mdadm is going to help, the kernel is old and=
=20
lacks a number of improvements in the last few years. I don't think you=
=20
will see any major improvements without a kernel upgrade.

--=20
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will stil=
l
  be valid when the war is over..." Otto von Bismark=20



-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
