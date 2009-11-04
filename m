From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Successful RAID 6 setup
Date: Wed, 4 Nov 2009 12:40:44 -0600
Message-ID: <20091104184049356.ZIDJ2725@cdptpa-omta04.mail.rr.com>
References: <4AF1C20C.4090902@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF1C20C.4090902@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I will preface this by saying I only need about 100MB/s out of my array
> because I access it via a gigabit crossover cable.

	That's certainly within the capabilities of a good setup.

> I am backing up all of my information right now (~4TB) with the
> intention of re-creating this array with a larger chunk size and
> possibly tweaking the file system a little bit.
> 
> My original array was a raid6 of 9 WD caviar black drives, the chunk
> size was 64k. I use USAS-AOC-L8i controllers to address all of my drives
> and the TLER setting on the drives is enabled for 7 seconds.

	I would recommend a larger chunk size.  I'm using 256K, and even
512K or 1024K probably would not be excessive.

> storrgie@ALEXANDRIA:~$ sudo mdadm -D /dev/md0
> /dev/md0:
>         Version : 00.90

	I definitely recommend something other than 0.9, especially if this
array is to grow a lot.

> I have noticed slow rebuilding time when I first created the array and
> intermittent lockups while writing large data sets.

	Lock-ups are not good.  Investigate your kernel log.  A write-intent
bitmap is recommended to reduce rebuild time.

> Is ext4 the ideal file system for my purposes?

	I'm using xfs.  YMMV.

> Should I be investigating into the file system stripe size and chunk
> size or let mkfs choose these for me? If I need to, please be kind to
> point me in a good direction as I am new to this lower level file system
> stuff.

	I don/'t know specifically about ext4, but xfs did a fine job of
assigning stripe and chunk size.

> Can I change the properties of my file system in place (ext4 or other)
> so that I can tweak the stripe size when I add more drives and grow the
> array?

	One can with xfs.  I expect ext4 may be the same.


