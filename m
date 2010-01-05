From: Khelben Blackstaff <eye.of.the.8eholder@gmail.com>
Subject: Re: Alignment of RAID on specific boundary
Date: Tue, 5 Jan 2010 15:44:10 +0200
Message-ID: <7b3edae11001050544p4f99d7dbq83b72e385151c27@mail.gmail.com>
References: <7b3edae11001041130n42d053fcpc4923b22278c5671@mail.gmail.com>
	 <4877c76c1001042257h49103054t977de11410eb65c6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c1001042257h49103054t977de11410eb65c6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2010/1/5 Michael Evans <mjevans1983@gmail.com>:
> On Mon, Jan 4, 2010 at 11:30 AM, Khelben Blackstaff
> <eye.of.the.8eholder@gmail.com> wrote:
>
> You want the RAID data chunks aligned so that they start on a 512byte
> sector address that fulfills (sector & 0xFF) =3D=3D 0.
>
> Format 1.1 will reserve the space at the beginning, and I have just c=
hecked;
>
> 00000400 =C2=A000 00 00 00 00 00 00 00 =C2=A000 00 00 00 00 00 00 00 =
=C2=A0|................|
> *
> 00003000 =C2=A0(LVM2 header)
>
> It starts the LVM2 header after 0x3000 bytes (64K chunk size); I'd
> hope to see it around 0x10000.
>
> It looks like the data isn't padded up to the desired offset.
>
> I agree, it would be useful to have an option to specify the offset o=
f
> the first data chunk.
>

Thank you for bringing hexdump to my attention. I had completely
forgot to run it. After reading your post i thought to run hexdump too.

I wrote 10MB of 1s (0x31 in HEX) to both partitions. So "0x31"
means "space untouched by mdadm". Then created the array
and wrote 10KB of 2s (0x32) to it. So "0x32" means "actual data".
The hexdump output is the following:

0000110 FFFF FFFF FFFF FFFF
*
0000400 3131 3131 3131 3131
*
0011000 3232 3232 3232 3232

The data written by mdadm (the superblock i guess) ends at 0x400
like you posted. So the v1.1 raid superblock has 1K size i guess.
In my case the payload starts at 0x11000 (the space between 0x400
and 0x11000 is maybe where the bitmap lives ?)

0x11000 =3D 69632 bytes =3D 136 sectors

Then my understanding of "data offset" is correct. I need to move
this offset from 136 sectors to 512 sectors.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
