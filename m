From: Steven Haigh <netwiz@crc.id.au>
Subject: Re: Disk I/O error while rebuilding an md raid-5 array
Date: Tue, 09 Feb 2010 15:26:32 +1100
Message-ID: <614f278c776be50b11520bfd3e2168ae@localhost>
References: <adf93d751002081523y1b9de656kdbba276b3dbc6af4@mail.gmail.com> <adf93d751002081723u1c14371bj21807dcd508b3962@mail.gmail.com> <7a329d911002082024j50fba7fcq717fe03d00209533@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7a329d911002082024j50fba7fcq717fe03d00209533@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 8 Feb 2010 22:24:09 -0600, Wil Reichert <wil.reichert@gmail.com=
>
wrote:
> On Mon, Feb 8, 2010 at 7:23 PM, Dawning Sky <the.dawning.sky@gmail.co=
m>
> wrote:
>> On Mon, Feb 8, 2010 at 3:23 PM, Dawning Sky <the.dawning.sky@gmail.c=
om>
>> wrote:
>>> It appears clonezilla is using dd and the speed is extremely
>>> slow (~5MB/sec) and it says it's gonna take 1 day to clone the 500G=
B.
>>
>> BTW, is it normal for dd to be this slow, or is there something wron=
g
>> with my setup? =C2=A0These are quite modern drives and should be abl=
e to
>> handle sequential transfer of 10's of MB/s. =C2=A0I have never used =
dd
>> before so I don't have any experience.
>=20
> dd should be pretty close to the max possible throughput of yer drive=
=2E
>  For example, I dd'd a 1T WD black not too long ago & it was around
> 120MB/s on the outside & 70MB/s in the middle.

I think this depends more on the block size that is used. 1MB block siz=
es
are much faster than 512 byte blocks...

--=20
Steven Haigh
=20
Email: netwiz@crc.id.au
Web: http://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897
=46ax: (03) 8338 0299
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
