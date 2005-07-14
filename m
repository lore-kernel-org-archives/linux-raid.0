From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Oops when starting md multipath on a 2.4 kernel
Date: Thu, 14 Jul 2005 12:13:29 +0200
Message-ID: <20050714101329.GI25179@marowsky-bree.de>
References: <42D546AB.6060101@moving-picture.com> <42D5FCA4.10104@us.ibm.com> <42D639DC.80608@moving-picture.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <42D639DC.80608@moving-picture.com>
Sender: linux-raid-owner@vger.kernel.org
To: James Pearson <james-p@moving-picture.com>, Mike Tran <mhtran@us.ibm.com>
Cc: lnx1138@us.ibm.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2005-07-14T11:09:32, James Pearson <james-p@moving-picture.com> wrot=
e:

> Thanks - that patch applies OK to more recent 2.4 kernels and appears=
 to=20
> 'fix' this problem.
>=20
> However, if you have a cut down patch that fixes just this problem, t=
hen=20
> I would appreciate it if you could make it available.

There's a bugfix needed for 2.4 md multipath which prevents guaranteed =
data
corruption on failover too. I don't have time to redo the diffs against
2.4 proper, but

-                       bh->b_rdev =3D bh->b_dev;
-                       bh->b_rsector =3D bh->b_blocknr;

are probably the two most important changes to multipath.c:multipathd()=
=2E

The patch in the SLES8 2.4 kernel is
patches.common/md-multipath-retry-handling - there's also some locking
fixes etc in there.

The problem is our kernel has deviated so much from 2.4, and active
development is now focused on DM mpath in 2.6, that pulling out smaller
chunks and feeding them upstream on 2.4 just isn't worth it :-(


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business	 -- Charles Darwin
"Ignorance more frequently begets confidence than does knowledge"

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
