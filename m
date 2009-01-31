From: =?ISO-8859-1?Q?Tor_Arne_Vestb=F8?= <torarnv@gmail.com>
Subject: Re: Linux RAID autodetect partitions go missing from /dev, but fdisk
 can see them
Date: Sat, 31 Jan 2009 14:19:21 +0100
Message-ID: <49844FD9.2090705@gmail.com>
References: <49402CFE.3080708@gmail.com>	<18759.8246.568849.244513@notabene.brown>	<494AC8BA.7010704@gmail.com> <18762.53424.819087.495066@notabene.brown> <49736C2A.3050108@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49736C2A.3050108@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tor Arne Vestb=F8 wrote:
> Neil Brown wrote:
>> If a partition start at an offset in the device which is a multiple =
of
>> 64K, and ends at the end of the device, then both the partition and
>> the whole device will appear to have the same superblock.  This can
>> cause confusion.
>=20
> I think you are on to something here! I did partition all my disks wi=
th
> just one partition, starting on the first block and taking up all the
> remaining space, and set it to type Linux RAID auto detect.

[snip]

> So is this a case of the problem you described about
> superblock-confusion? If so, is it fixable?

It appears it is :)

=46or googlability, here's what I did:

Changed the DEVICE line in my mdadm.conf from:

  DEVICE partitions

to

  DEVICE /dev/sd[bcdef]1

Now the array is assembled correctly at boot.

I'm still confused why the device nodes went missing as a result of the
failed assembly earlier, but that's a minor issue I can live with :)

Tor Arne
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
