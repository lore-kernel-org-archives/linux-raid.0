From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: raid1 - ssd, doubts
Date: Tue, 30 Sep 2014 13:20:41 -0300
Message-ID: <CAH3kUhFwakMSRAgKdSR-4g53KwHS6Yj_mmm3TOVKRQ_qaA9SNA@mail.gmail.com>
References: <CAH3kUhHkot3doqVZQ0TAot0A3e8i8RFWqsiLL35p1OYsvz5Xkw@mail.gmail.com>
	<542AD06C.9080908@redhost.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <542AD06C.9080908@redhost.ro>
Sender: linux-raid-owner@vger.kernel.org
To: Andrei Banu <andrei.banu@redhost.ro>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

nice :) well today it use hdd with sata, 500GB with raid 1 (2 disks)
the only problem is the disk being old, i must replace it
i'm considering ssd only by the price and myth, hdd works well today
i have some doubts about performace without the raid card as you told,
the last ssd i used was enterprise level not desktop/non enterprise
level, and with a raid card

well, others experiences and comments are wellcome :)
comments about cache (bcache,flashcache,dm cache) are wellcome too


2014-09-30 12:46 GMT-03:00 Andrei Banu <andrei.banu@redhost.ro>:
> Hi,
>
> I am in no way of the same technical caliber as many of the people on=
 this
> list so please take my advice with a grain of salt. However I do have=
 some
> experience with Samsung SSDs in RAID 1 software (md-raid) and I would=
 like
> to warn you against it.
>
> My setup is with 840 PROs of 512GB. I did leave free space (not parti=
tioned)
> for OP. The SSDs are connected on SATA3.
>
> I'll give you the result of 2 tests and if you are happy, go ahead:
>
> READ
> root [~]# hdparm -t /dev/sda
> /dev/sda:
>  Timing buffered disk reads: 292 MB in  3.01 seconds =3D  96.92 MB/se=
c
>
> WRITE
> root [~]# dd if=3D/dev/zero of=3Dtestn bs=3D4k count=3D256k conv=3Dfd=
atasync
> 262144+0 records in
> 262144+0 records out
> 1073741824 bytes (1.1 GB) copied, 13.4047 s, 80.1 MB/s
>
> When the setup is fresh you'll get significantly more out of it but a=
fter a
> while
> (this setup is roughly 1 year old) this is what you get with Samsung =
SSDs in
> RAID1 SW. At least this is my experience and I did try to improve it.=
 As a
> matter
> of fact, before making a secure erase of one of the SSDs the write sp=
eed was
> under 10MB/s. What you see above is a lot better than what it started=
 out
> (but it's true that after the secure erase the read/write speeds were=
 a lot
> better but it dropped in a very short time frame).
>
> A few points:
> 1. CAUTION: 840 EVO are proved to have a read speed degradation for o=
ld
> data written to the drive (this is unrelated to RAID but it probably =
affects
> performance in RAID).
> 2. I believe that any SSDs, regardless of the brand, in a software RA=
ID-1
> setup
> might be a bad idea.
> 3. I believe that the same SSDs in a hardware RAID setup might lead t=
o a
> different story.
>
> Again: I am not a technical wiz (like many of the people on this list=
) but I
> did
> have some experience with this so I thought I should let you know.
>
> Kind regards!
>
>
>
>
> On 30.09.2014 17:50, Roberto Spadim wrote:
>>
>> hi guys!
>> i will use a ssd raid1, i want know if raid1 trim is supported at md=
adm
>> i will use a 840 evo (or evo pro not selected the right one yet) 500=
gb
>> each, raid1, today database size is 100gb, i think it will grow
>> 10gb/year, i had many space...
>>
>> the point are: madm raid1 trim is supported? or should i use lvm?
>> should i partition it with 400gb and leave 100gb untouched? or shoul=
d
>> i use a hdd+ssd and dmcache?
>>
>>
>> :) thanks guys, that's a small enterprise solution, they can't buy
>> raid cards and sas harddisk are same price of ssd :)
>>
>> any idea/experience and information is wellcome
>>
>>
>



--=20
Roberto Spadim
SPAEmpresarial
Eng. Automa=C3=A7=C3=A3o e Controle
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
