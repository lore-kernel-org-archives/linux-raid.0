From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: "Enhanced" MD code avaible for review
Date: Thu, 25 Mar 2004 23:04:34 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040325220434.GW15264@marowsky-bree.de>
References: <760890000.1079727553@aslan.btc.adaptec.com> <16480.61927.863086.637055@notabene.cse.unsw.edu.au> <40624235.30108@pobox.com> <200403251200.35199.kevcorry@us.ibm.com> <40632804.1020101@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <40632804.1020101@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>, Kevin Corry <kevcorry@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Neil Brown <neilb@cse.unsw.edu.au>, "Justin T. Gibbs" <gibbs@scsiguy.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2004-03-25T13:42:12,
   Jeff Garzik <jgarzik@pobox.com> said:

> >and -5). And we've talked for a long time about wanting to port RAID=
-1 and=20
> >RAID-5 (and now RAID-6) to Device-Mapper targets, but we haven't sta=
rted=20
> >on any such work, or even had any significant discussions about *how=
* to=20
> >do it. I can't=20
> let's have that discussion :)

Nice 2.7 material, and parts I've always wanted to work on. (Including
making the entire partition scanning user-space on top of DM too.)

KS material?

> My take on things...  the configuration of RAID arrays got a lot more=
=20
> complex with DDF and "host RAID" in general.

And then add all the other stuff, like scenarios where half of your RAI=
D
is "somewhere" on the network via nbd, iSCSI or whatever and all the
other possible stackings... Definetely user-space material, and partly
because it /needs/ to have the input from the volume managers to do the
sane things.

The point about this implying that the superblock parsing/updating logi=
c
needs to be duplicated between userspace and kernel land is valid too
though, and I'm keen on resolving this in a way which doesn't suck...


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
