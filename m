From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: "Enhanced" MD code avaible for review
Date: Fri, 26 Mar 2004 00:44:52 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040325234452.GC15264@marowsky-bree.de>
References: <760890000.1079727553@aslan.btc.adaptec.com> <16480.61927.863086.637055@notabene.cse.unsw.edu.au> <40624235.30108@pobox.com> <200403251200.35199.kevcorry@us.ibm.com> <1019470000.1080255540@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1019470000.1080255540@aslan.btc.adaptec.com>
To: "Justin T. Gibbs" <gibbs@scsiguy.com>, Kevin Corry <kevcorry@us.ibm.com>, linux-kernel@vger.kernel.org
Cc: Jeff Garzik <jgarzik@pobox.com>, Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2004-03-25T15:59:00,
   "Justin T. Gibbs" <gibbs@scsiguy.com> said:

> The fact of the matter is that neither EMD nor DM provide a generic
> morphing capability.  If this is desirable, we can discuss how it cou=
ld
> be achieved, but my initial belief is that attempting any type of
> complicated morphing from userland would be slow, prone to deadlocks,
> and thus difficult to achieve in a fashion that guaranteed no loss of
> data in the face of unexpected system restarts.

Uhm. DM sort of does (at least where the morphing amounts to resyncing =
a
part of the stripe, ie adding a new mirror, RAID1->4, RAID5->6 etc).
=46reeze, load new mapping, continue.

I agree that more complex morphings (RAID1->RAID5 or vice-versa in
particular) are more difficult to get right, but are not that often
needed online - or if they are, typically such scenarios will have
enough temporary storage to create the new target, RAID1 over,
disconnect the old part and free it, which will work just fine with DM.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering	      \ ever tried. ever failed. no matt=
er.
SUSE Labs			      | try again. fail again. fail better.
Research & Development, SUSE LINUX AG \ 	-- Samuel Beckett

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
