From: adfas asd <chimera_god@yahoo.com>
Subject: Re: Remote NAS
Date: Wed, 23 Sep 2009 15:58:41 -0700 (PDT)
Message-ID: <117705.89087.qm@web38807.mail.mud.yahoo.com>
References: <20090923210145.GA23285@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090923210145.GA23285@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--- On Wed, 9/23/09, Keld J=F8rn Simonsen <keld@dkuug.dk> wrote:
> Writes are about the same for RAID10 types and RAID1.
> This is also what theory would tell for random writes,
> given that they
> are random, and that the elevator algorithm of the file
> system optimizes
> the writing.=20
>=20
> Yes, offset came after far, but Neil Brown said that offset
> was
> implemented to make Linux MD align to RAID standards. It
> was not
> necessarily meant to be better than far.=20
>=20
> I think it is hard to beat raid10 far on reads (but then I
> am also the
> one that invented the layout). As said for random reading
> and writing
> the theory says that all mirrored raid types perform
> equally, and tests
> verify this. Maybe far layout even has an edge for random
> reading, in
> theory it should, but I have not seen tests really
> verifying that.

Excellent, thanks Keld.




     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
