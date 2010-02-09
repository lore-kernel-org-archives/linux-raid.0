From: Wil Reichert <wil.reichert@gmail.com>
Subject: Re: Disk I/O error while rebuilding an md raid-5 array
Date: Mon, 8 Feb 2010 22:24:09 -0600
Message-ID: <7a329d911002082024j50fba7fcq717fe03d00209533@mail.gmail.com>
References: <adf93d751002081523y1b9de656kdbba276b3dbc6af4@mail.gmail.com>
	 <adf93d751002081723u1c14371bj21807dcd508b3962@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <adf93d751002081723u1c14371bj21807dcd508b3962@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dawning Sky <the.dawning.sky@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Feb 8, 2010 at 7:23 PM, Dawning Sky <the.dawning.sky@gmail.com>=
 wrote:
> On Mon, Feb 8, 2010 at 3:23 PM, Dawning Sky <the.dawning.sky@gmail.co=
m> wrote:
>> It appears clonezilla is using dd and the speed is extremely
>> slow (~5MB/sec) and it says it's gonna take 1 day to clone the 500GB=
=2E
>
> BTW, is it normal for dd to be this slow, or is there something wrong
> with my setup? =C2=A0These are quite modern drives and should be able=
 to
> handle sequential transfer of 10's of MB/s. =C2=A0I have never used d=
d
> before so I don't have any experience.

dd should be pretty close to the max possible throughput of yer drive.
 For example, I dd'd a 1T WD black not too long ago & it was around
120MB/s on the outside & 70MB/s in the middle.

Wil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
