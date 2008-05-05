From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: Re: How to grow RAID1 mirror on top of LVM?
Date: Mon, 5 May 2008 09:10:52 +0200
Message-ID: <20080505091052.e6389586.taeuber@bbaw.de>
References: <25F8EF57-9606-4217-B2D4-2DD3D8E064C4@cam.ac.uk>
	<18408.36712.100712.499844@notabene.brown>
	<20080428162556.00ee0d72.taeuber@bbaw.de>
	<18458.34575.416075.798546@notabene.brown>
	<1209740806.4319.26.camel@russ-ifl90>
	<18461.39961.921994.904814@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18461.39961.921994.904814@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Russ Hammer <russ@perneus.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi there!

Neil Brown <neilb@suse.de> schrieb:
> The only possible problem area in your recipe is if the drives are no=
t
> actually identical (not all 750GB drive have the same number of
> blocks), the array you get with the -G command might be too big to
> allow the partition you create on the new sda.  However if the drives
> do have exactly the same number of sectors, this will not be a proble=
m.

I think this problem is not true if you grow the array after including =
the second bigger disk. Because then all involved partition and their s=
izes are known.
Am I right?

Greetings
Lars
--=20
                            Informationstechnologie
Berlin-Brandenburgische Akademie der Wissenschaften
J=C3=A4gerstrasse 22-23                     10117 Berlin
Tel.: +49 30 20370-352           http://www.bbaw.de
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
