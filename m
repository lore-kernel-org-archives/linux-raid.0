From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [PATCH] secure write for RAID1
Date: Wed, 27 Apr 2005 08:05:31 +0200
Message-ID: <20050427060531.GH4431@marowsky-bree.de>
References: <1toqj2-sjd.ln1@news.it.uc3m.es> <17007.1524.476174.515614@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17007.1524.476174.515614@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2005-04-27T13:24:36, Neil Brown <neilb@cse.unsw.edu.au> wrote:

> On Saturday April 23, ptb@lab.it.uc3m.es wrote:
> > This patch (completely untested of course - what, me?) makes RAID1 =
write
> > to all components of a raid-1 array, else return error to the write
> > attempt, when one component cannot be written.
> I don't understand why or when you would want this.
>=20
> This wouldn't just return an error to the application if the write
> wasn't completely safe.  It would cause the filesystem to switch to
> read-only very quickly and make your machine un-usable.  Is that
> really what you want??

Databases sometimes want this (also for replication).

They'd rather fail than potentially lose a committed transaction, and t=
o
that end they require that the data be written to at least two disks; i=
e
they want the data to be able to withstand at least one failure.  We've
had such a request from a big database vendor for drbd too.

(This however is a great application for >2 mirrors and a write quorum
of two, though.)


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
