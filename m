From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [PATCH md 4 of 4] "Faulty" personality of md
Date: Tue, 2 Nov 2004 10:31:41 +0100
Message-ID: <20041102093141.GH32712@marowsky-bree.de>
References: <20041102143440.12019.patches@notabene> <E1COpUP-000396-JF@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <E1COpUP-000396-JF@notabene.cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@cse.unsw.edu.au>, Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2004-11-02T14:37:45, NeilBrown <neilb@cse.unsw.edu.au> wrote:

> The 'faulty' personality provides a layer over any block device
> in which errors may be synthesised.
>=20
> A variety of errors are possible including transient and persistent
> read and write errors, and read errors that persist until the next
> write.
>=20
> There error mode can be changed on a live array.

Duplicates functionality already present with the device-mapper error
target, or functionality present with the (not yet merged) flakey dm
target.

I think we should strive for convergence, not for more duplication.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX AG - A Novell company

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
