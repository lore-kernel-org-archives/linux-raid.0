From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Alternative to RAID... No change to Data HDDs, only one simple "modulo"-Disk
Date: Mon, 21 Jun 2004 17:55:18 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040621155518.GJ28927@marowsky-bree.de>
References: <200406182019.i5IKJe327151@watkins-home.com> <Pine.LNX.4.44.0406210916400.4059-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0406210916400.4059-100000@coffee.psychology.mcmaster.ca>
To: Mark Hahn <hahn@physics.mcmaster.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2004-06-21T09:22:41,
   Mark Hahn <hahn@physics.mcmaster.ca> said:

> afaikt, he's just looking for an incremental raid system,
> which is understandably attractive.  keeping track of which=20
> blocks are on N disks and which have been migrated to N+1
> might be tricky, though.  certainly not impossible.

It's the volume manager's job to do that. I can easily allocate blocks
from all disks for whatever RAID level you want etc. I believe EVMS can
actually do that, even. If not, it should be added ;-)


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
