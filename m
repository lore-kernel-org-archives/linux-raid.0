From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re: Nested raid operation and disk sizes
Date: Tue, 5 Aug 2008 21:35:10 +0100
Message-ID: <18584.47486.900993.496893@tree.ty.sabi.co.uk>
References: <925039.86717.qm@web30804.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <925039.86717.qm@web30804.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

> [ ... add to one 4+1 1TB RAID5 three 1+1 0.5TB RAID0s ... ]

> [ ... ] as once the data is moved there, and the disks removed
> from the 8x500GB set, there is no going back...  :-)

So no backup? It is the cherry on the cake of a RAID5 that is
grown from 4 to 7 members.

> Does this sound like it should work?

"Do you feel lucky?" seems appropriate here.

This is a classic example of what I call a "syntactic" approach
to configuration: if the configuration is syntactically valid
(concats of 12+1 RAID5s, ...) then  fine.

The idea of growing 3 times a 4+1 RAID5 into a 7+1 RAID5 three
of whose members are 1+1 RAID0s (thus 1 drive of redundancy for
10 drives of data) is indeed syntactically valid as well as
exceedingly clever; whether it is wise, especially with no
backups, depends on how lucky one feels.

Feeling very lucky like so many people on this list?
Go ahead and make your day :-).
