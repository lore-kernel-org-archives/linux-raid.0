From: Carlos Williams <carloswill@gmail.com>
Subject: Re: How To Grow Using 'mdadm' Utility
Date: Thu, 28 Jan 2010 11:05:33 -0500
Message-ID: <d80f793f1001280805w3f7dee29n8afdb287494d7673@mail.gmail.com>
References: <d80f793f1001271056i1127fbcege5b4dd4a3927576@mail.gmail.com>
	 <1264634977.1928.13.camel@test.apertos.eu>
	 <d80f793f1001280658k487be15emc0a6d23c9d013957@mail.gmail.com>
	 <1264691314.1928.27.camel@test.apertos.eu>
	 <d80f793f1001280713j5b0ee689m1c4c455403c64928@mail.gmail.com>
	 <1264692194.1928.29.camel@test.apertos.eu>
	 <d80f793f1001280750n68257e18n3e79ec0d68b5ac18@mail.gmail.com>
	 <1264694363.1928.30.camel@test.apertos.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1264694363.1928.30.camel@test.apertos.eu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2010/1/28 Micha=C5=82 Sawicz <michal@sawicz.net>:
> You would still need resize2fs to run on a running, mounted FS - it's
> slow and smells of trouble.

Thanks all. Last question. If I have my system as 3 disks in RAID5
array and the 4th disk as a hot spare. Do I still need to format the
4th disk with a filesystem (ext4)? Or will that occur when the
software discovers a disaster in the RAID volume and then starts to
sync the 'hot spare' into the degraded array to take the place of the
failed drive?

The 4th disk does have a 'fd' (RAID) partition table created but no
file system. Just trying to understand how that would work...
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
