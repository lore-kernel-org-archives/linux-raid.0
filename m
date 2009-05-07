From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Incorrect in-kernel bitmap on raid10
Date: Thu, 7 May 2009 22:25:32 +0200
Message-ID: <slrnh06gts.8gr.Mario.Holbe@darkside.dyn.samba-tng.org>
References: <slrnguk663.8bq.Mario.Holbe@darkside.dyn.samba-tng.org>
 <18922.50050.860008.242658@notabene.brown>
 <slrnguupf4.911.Mario.Holbe@darkside.dyn.samba-tng.org>
 <slrngve39c.8a2.Mario.Holbe@darkside.dyn.samba-tng.org>
 <18938.23135.726382.733302@notabene.brown>
 <20090501175524.GA8163@darkside.22.kls.lan>
 <fb9dbbffc38b437042076747a41ddf9b.squirrel@neil.brown.name>
 <20090502195259.GA8499@darkside.22.kls.lan>
 <a960aae116852f769f6e223581fa6835.squirrel@neil.brown.name>
 <20090503132230.GA23302@darkside.22.kls.lan>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE> wrote:
> No, mdadm -A /dev/md7; mdadm --add /dev/md7 /dev/sd[fgh]1 seems to
> respect the bitmap, but first adds the first spare only and the two
...
> According to your previous mail, I will run into your case 3/ this way,
> the bug where the bitmap is cleared too early, will I?

All right, I applied your "[md PATCH 2/7] md/raid10: don't clear bitmap
during recovery if array will still be degraded." patch, modified about
2% of my fully degraded raid10, synched the 3 missing devices, compared
the mirrors and found no difference, so I guess I can confirm the patch
works for me :)


regards
   Mario
-- 
The opposite of a correct statement is a false statement.
But the opposite of a profound truth may well be another profound truth.
                                                           -- Niels Bohr

