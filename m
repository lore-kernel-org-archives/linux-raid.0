From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: If your using large Sata drives in raid 5/6 ....
Date: Tue, 2 Feb 2010 17:46:25 -0500
Message-ID: <87f94c371002021446y38dce6fds6acca2b4919ad773@mail.gmail.com>
References: <87f94c371002021440o3b30414bk3a7ccf9d2fa9b8af@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87f94c371002021440o3b30414bk3a7ccf9d2fa9b8af@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

All,

I think the below is accurate, but please cmiiw or misunderstand.

=3D=3D=3D
If your using normal big drives (1TB, etc.) in a raid-5 array, the
general consensus of this list is that it is a bad idea. =A0The reason =
being
that the sector error rate for a bad sector has not changed with
increasing density.

So in the days of 1GB drives, the likelihood of a undetected /
repaired bad sector was actually pretty low for the drive as whole.
But for today's 1TB drives, the odds are 1000x worse. =A0ie. 1000x more
sectors with the same basic failure rate per sector.

So a raid-5 composed of 1TB drives is 1000x more likely to be unable
to rebuild itself after a drive failure than a raid-5 built from 1 GB
drives of yesteryear. =A0Thus the current recommendation is to use raid
6 with high density drives.

The good news is that Western Digital is apparently introducing a new
series of drives with an error rate "2 orders of magnitude" better
than the current generation.

See <http://www.anandtech.com/storage/showdoc.aspx?i=3D3691&p=3D1>

The whole article is good, but this paragraph is what really got my att=
ention:

"From a numbers perspective, Western Digital estimates that the use of
4K sectors will give them an immediate 7%-11% increase in format
efficiency. ECC burst error correction stands to improve by 50%, and
the overall error rate capability improves by 2 orders of magnitude.
In theory these reliability benefits should immediately apply to all
4K sector drives (making the Advanced Format drives more reliable than
regular drives), but Western Digital is not pushing that idea at this
time."

So maybe raid-5 will once again be a reasonable choice again in the
future.

(I think these drives may already be available at least as
engineering samples.  Basic linux kernel support went in summer 2009 I
believe. I believe 2.6.33 will be the first kernel to have been tested
with these new class of drives.)

I don't know if there is a mdraid wiki, but if so and someone wants to
post the above there, please do.

Greg
--
Greg Freemyer
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
