From: Seb <seb@h-k.fr>
Subject: Re: Partitions with == or \approx same size ?
Date: Sat, 21 Jul 2007 02:41:31 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0707210235000.30683@ybpnyubfg.ybpnyqbznva>
References: <Pine.LNX.4.58.0707201908020.30683@ybpnyubfg.ybpnyqbznva>
 <18081.11720.547650.571674@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18081.11720.547650.571674@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi Neil,


| > Could you tell me if such a mechanism exists in mdadm?
| > Or should I accept the "loss" of the 150 GB?
| When you give mdadm a collection of drives to turn into a RAID array,
| use bases the size of the array on the smallest device.

I'm sorry I don't know what "bases" are in a RAID array and I can't fin=
d
this term in the man page. Could you elaborate?

| You might want to make it a little smaller still in case you have to
| replace a device with a slightly smaller device (it happens).  You ca=
n
| use "--size" to reduce the used space a little further if you like.

Thanks for the pointer to --size! I had overlooked this option. The man
page says that "If  this is not specified (as it normally is not) the
smallest drive (or partition) sets the size". This implies that partiti=
ons
need not have exactly the same size and 'mdadm' will still manage.

So I'll use 249,9GB out of 250GB, skip over the small resulting
differences, let mdadm work its magic and when new disks will be insert=
ed
after a failure it will suffice to use their total space.


Best,
S=E9bastien.
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
