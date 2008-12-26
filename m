From: "Greg Freemyer" <greg.freemyer@gmail.com>
Subject: RFC: detection of silent corruption via ATA long sector reads
Date: Fri, 26 Dec 2008 16:44:57 -0500
Message-ID: <87f94c370812261344s3f70de25r4d132101d2247e00@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Redeeman <redeeman@metanurb.dk>
Cc: piergiorgio.sartor@nexgo.de, neilb@suse.de, linux-raid@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Mark Lord <liml@rtr.ca>
List-Id: linux-raid.ids

All,

On the mdraid list, there was a recent thread about using raid
functionality to detect / repair silent corruption.

The issues brought up were that a lot of silent data corruption occurs
when cables, controllers, power supplies, ram, cache, etc. goes bad.

It made me think about another option for detecting silent corruption
I have not seen discussed, but maybe I missed it.

Aiui, the ATA spec allows for the reading of a long sector as well as
the normal 512 byte sector.  When you get a long sector you also get
the CRC (or whatever checksum data there is on the disk that allows
the drive itself to detect media errors).

I don't have any idea how easy or hard it would be to do, but I would
like to see the entire block subsystem enhanced to optionally allow
long sector reads to be used in a "paranoid" fashion.

Effectively it would be:

1) Read long sector from drive:  verify CRC in kernel.  This tests
most everything on the i/o path.

2) maintain CRC type information in block subsystem.  Verify no
corruption just before handing off to userspace.  This would
potentially identify CPU/cache/RAM failures.

Mark Lord has implemented long sector reads via hdparm.  Mark can you
comment on the feasibility of this idea?

Thanks
Greg
-- 
Greg Freemyer
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
First 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.pdf

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
