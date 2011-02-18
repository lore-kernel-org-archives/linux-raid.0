From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: md road-map: 2011
Date: Fri, 18 Feb 2011 17:22:31 -0200
Message-ID: <AANLkTi=JsXwAVOi96aRVVwWnnJS0uPGMV+Fbi4u46G92@mail.gmail.com>
References: <20110217010455.GA16324@www2.open-std.org>
	<ijiu99$ill$1@dough.gmane.org>
	<20110217105815.GA24580@www2.open-std.org>
	<4D5D0A66.80608@texsoft.it>
	<20110217154440.GA24982@www2.open-std.org>
	<4D5DB9AC.10106@texsoft.it>
	<20110218025623.GA26387@www2.open-std.org>
	<4D5E4030.8020805@texsoft.it>
	<20110218184329.GA2297@www2.open-std.org>
	<AANLkTinYkEsaWinaz4LaOBpT36+fpizCSFO=AfH7sWEA@mail.gmail.com>
	<20110218191820.GA2517@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110218191820.GA2517@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>
Cc: Giovanni Tessore <giotex@texsoft.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

yeah, disk with badblock =3D disk with dynamic layout
i think with badblock we could port layout to all raid systems
(including raid1 hehe, i like raid1)

the area for badblock, we could clena then at startup with: write
000000, send TRIM command to sectors used by badblock area, this will
help disks with internal realloc functions (faster than md software)

2011/2/18 Keld J=F8rn Simonsen <keld@keldix.com>:
> On Fri, Feb 18, 2011 at 05:00:27PM -0200, Roberto Spadim wrote:
>> again... for realloc we need TRIM command or reserved sectors just f=
or
>> bad block realloc, TRIM command tell MD what sector isn?t in use, at
>> WRITE command MD set the sector as inuse, at array creation md set
>> sector as inuse too. this will only work with ext4 and swap, others
>> filesystem don?t have TRIM. the solution of others filesystem are
>> based on not used block, but it?s a internal logic of each filesyste=
m.
>> i don?t know what is best, TRIM command is nice (we can send TRIM to
>> disks, this help to make their life bigger) a bad block is a disk
>> getting smaller and smaller, the disk can realloc badblock. if it
>> cant, filesystem should realloc it (it have more information about
>> logic device, it shouldn?t, TRIM command is the information that dis=
k
>> should have to discart blocks, not a filesystem logic, but... it?s a
>> option, filesystem can realloc)
>
> I think I prefer a realloc area in the raid metadata area. And the
> metadata area could be contaning a not-too-small realloc area, with a=
n
> option of enlarging the realloc area at a later time. This could be d=
one
> by shrinking the related file system, and then adding the freed space=
 to
> the realloc area in the raid metadata.
>
> Some MBs set aside for this would not be noticeable in todays TB disk=
s
> regime. I think current disk hardware allows relocation of under 1000
> blocks a 512 byte =3D under 512 kB. So no problem sizewise.
> Performance may be a bigger problem. =A0Maybe some binary searcheable=
 list
> built at MD RAID assembly time.
>
> best regards
> keld
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
