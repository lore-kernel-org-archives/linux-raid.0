From: Paul Clements <paul.clements@us.sios.com>
Subject: Re: possible bug - bitmap dirty pages status
Date: Wed, 31 Aug 2011 08:30:36 -0400
Message-ID: <CAECXXi5eo3J8PPXP5xTm-PrqazC_fkwNnjtiAGM4NtsGBMahHA@mail.gmail.com>
References: <CAGqmV7oKNSj2UjEKyqwE2qKrTj9Gj5-OZxwUAVw+uMh1TTRXuA@mail.gmail.com>
	<CAGqmV7pjvEHaNWjuZzt+tSsUJOM28ZqDY6qUROzz8GtMGCxDow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGqmV7pjvEHaNWjuZzt+tSsUJOM28ZqDY6qUROzz8GtMGCxDow@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Aug 31, 2011 at 5:05 AM, CoolCold <coolthecold@gmail.com> wrote=
:

>> root@gamma2:~# cat /proc/mdstat
>> Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
>> md3 : active raid1 sdc3[1] sdb3[0]
>> =A0 =A0 =A01443552640 blocks [2/2] [UU]
>> =A0 =A0 =A0bitmap: 16/22 pages [64KB], 32768KB chunk

> More details now:
> Array still has 16/22 dirty pages:

> root@gamma2:~# mdadm --examine-bitmap /dev/sdc3

> =A0 =A0 =A0 Sync Size : 1443552640 (1376.68 GiB 1478.20 GB)
> =A0 =A0 =A0 =A0 =A0Bitmap : 44054 bits (chunks), 189 dirty (0.4%)

But only 189 bits dirty. This means the bits are just distributed
across the disk (which is why you have 16/22 pages dirty).

Any activity on the disk? 189 bits could easily be explained by a
small amount of background disk activity on a disk that big.

--
Paul
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
