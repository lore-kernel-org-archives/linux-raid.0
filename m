From: adfas asd <chimera_god@yahoo.com>
Subject: Re: Remote NAS
Date: Wed, 23 Sep 2009 07:59:09 -0700 (PDT)
Message-ID: <501250.73276.qm@web38802.mail.mud.yahoo.com>
References: <20090923091328.GA19193@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090923091328.GA19193@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--- On Wed, 9/23/09, Keld J=F8rn Simonsen <keld@dkuug.dk> wrote:
> There is a setup described at=20
>=20
> http://linux-raid.osdl.org/index.php/Preventing_against_a_failing_dis=
k
>=20
> You can substitute raid10,o2 for raid10,f2 for the root
> partitions etc.
>=20
> Anyway, raid10,f2 should be faster than raid10,o2, for at
> least reads,
> while for writes it is about the same performance given
> that you employ
> a file system.

Thanks keld.  I used this procedure, which does about the same thing an=
d seems more clear, adapting it to RAID10-o2:
http://www.howtoforge.com/software-raid1-grub-boot-debian-etch

I could find no performance comparison with far and offset, and knew th=
at far improved on reads, so since offset came later inferred that it w=
ould have improved writes.  No objective data to confirm otherwise.




     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
