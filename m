From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [RFCI] How best to partition MD/raid devices in 2.6
Date: Fri, 14 Nov 2003 11:16:47 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20031114101647.GJ32211@marowsky-bree.de>
References: <16308.18387.142415.469027@notabene.cse.unsw.edu.au> <1068787304.4157.8.camel@localhost> <16308.26754.867801.131463@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16308.26754.867801.131463@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>, Daniel Gryniewicz <dang@fprintf.net>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2003-11-14T16:30:42,
   Neil Brown <neilb@cse.unsw.edu.au> said:

> There are issues with the raid superblock but assuming they can be
> solved, I want partitioning to work easily.
>=20
> Can LVM work happily with 'legacy' partitioning information?

I'd really suggest to run DM (either LVM2 or EVMS2) on top of md
instead. It's much more flexible; I don't see any benefit in 'old style=
'
partition information, which has all sorts of problems - ie,
non-transactional updates (_why_ were you running raid again? ;), stati=
c
as they can't be modified during runtime etc.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering	      \ ever tried. ever failed. no matt=
er.
SUSE Labs			      | try again. fail again. fail better.
Research & Development, SUSE LINUX AG \ 	-- Samuel Beckett
