From: Jon Lewis <jlewis@lewis.org>
Subject: Re: 1x 3ware controllers vs. 2x 3ware controllers
Date: Sat, 31 Jul 2004 10:24:13 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0407311020420.7852@web1.mmaero.com>
References: <Pine.LNX.4.44.0407311045460.4528-100000@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0407311045460.4528-100000@uplift.swm.pp.se>
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 31 Jul 2004, Mikael Abrahamsson wrote:

> You should never ever ever use raid5 with something that is write
> intensive, such as a database server. Raid5 is a cost compromise that is a
> little of everything, if you want protection and speed at the same time,
> you should use raid1 (and possible raid0 the raid1:s).

Hardware RAID5 or software RAID5?  My experience has been that even the
higher end hardware RAID5 cards I've dealt with give nowhere near the
performace you get with software RAID5.  HW RAID5 is a good way to make an
IO intensive system turn into a slug.

> I learnt this the hard way running a nntp (news) server.

The only RAID I'd do / have done with nntp servers is RAID1 for the system
and RAID0 for the spool...but with modern software you don't even need
RAID0 for the spool...you just keep telling it to use more drives for
spools.

----------------------------------------------------------------------
 Jon Lewis                   |  I route
 Senior Network Engineer     |  therefore you are
 Atlantic Net                |
_________ http://www.lewis.org/~jlewis/pgp for PGP public key_________
