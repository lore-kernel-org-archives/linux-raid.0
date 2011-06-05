From: Durval Menezes <durval.menezes@gmail.com>
Subject: Fwd: Maximizing failed disk replacement on a RAID5 array
Date: Sun, 5 Jun 2011 11:22:22 -0300
Message-ID: <BANLkTimOxCF7diZfeFgtqCBWKZVF2pxyLg@mail.gmail.com>
References: <BANLkTimBYFhjQ-sC9DhTMO+PG-Ox+A9S2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTimBYFhjQ-sC9DhTMO+PG-Ox+A9S2Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello folks,

A few days ago, the smartd daemon running on my Lucid system at home
(kernel 2.6.32-32-generic, mdadm 2.6.7.1) has started warning me about
a few (less than 50 so far) offline uncorrectable and other errors on
one of my 1.5TB HDs three-disk RAID5 array. This failing HD is still
online (ie, hasn't been kicked off the array), at least for now.

I have another disk ready for replacement, and I'm trying to determine
the safer (not necessarily the simpler) way of proceeding.

I understand that, if I do it the "standard" way (ie, power down the
system, remove the failing disk, add the replacement disk, then boot
up and use "mdadm --add" to add the new disk to the array) I run the
risk of running into unreadable sectors on one of the other two disks,
and then my RAID5 is kaput.

What I would really like to do is to be able to add the new HD to the
array WITHOUT removing the failing HD, somehow sync it with the rest,
and THEN remove the failing HD: that way, an eventual failed read from
one of the two other HDs could possibly be satisfied from the failing
HD (unless EXACTLY that same sector is also unreadable on it, which I
find unlikely), and so avoid losing the whole array in the above case.

So far, the only way I've been able to figure to do that would be to
convert the=A0 array from RAID5 to RAID6, add the new disk, wait for th=
e
array to sync, remove the failing disk, and then convert the array
back from RAID6 to RAID5 (and I'm not really sure that this is a good
idea, or even doable).

So, folks, what do you say? Is there a better way? Any gotchas in the
RAID5->RAID6->RAID6 approach?

Thanks,
--
=A0=A0 Durval Menezes.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
