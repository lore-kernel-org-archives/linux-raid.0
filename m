From: Drew <drew.kay@gmail.com>
Subject: Re: Maximizing failed disk replacement on a RAID5 array
Date: Mon, 6 Jun 2011 08:02:48 -0700
Message-ID: <BANLkTi=px08AWxfJJq+zNepCZM8aAsKECA@mail.gmail.com>
References: <BANLkTimBYFhjQ-sC9DhTMO+PG-Ox+A9S2Q@mail.gmail.com> <BANLkTimOxCF7diZfeFgtqCBWKZVF2pxyLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTimOxCF7diZfeFgtqCBWKZVF2pxyLg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Durval Menezes <durval.menezes@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I understand that, if I do it the "standard" way (ie, power down the
> system, remove the failing disk, add the replacement disk, then boot
> up and use "mdadm --add" to add the new disk to the array) I run the
> risk of running into unreadable sectors on one of the other two disks,
> and then my RAID5 is kaput.
>
> What I would really like to do is to be able to add the new HD to the
> array WITHOUT removing the failing HD, somehow sync it with the rest,
> and THEN remove the failing HD: that way, an eventual failed read from
> one of the two other HDs could possibly be satisfied from the failing
> HD (unless EXACTLY that same sector is also unreadable on it, which I
> find unlikely), and so avoid losing the whole array in the above case.

A reshape from RAID5 -> RAID6 -> RAID5 will hammer your disks so if
either of the other two are ready to die, this will most likely tip
them over the edge.

A far simpler way would be to take the array offline, dd (or
dd_rescue) the old drive's contents onto the new disk, pull the old
disk, and restart the array with the new drive in it's place. With
luck you won't need a resync *and* you're not hammering the other two
drives in the process.


-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie

"This started out as a hobby and spun horribly out of control."
-Unknown
