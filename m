From: Andrew Beresford <beezly@beezly.org.uk>
Subject: RAID autorun support for SunOS disk labels
Date: Fri, 26 Apr 2002 11:11:01 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020426101101.GA25225@monkey.beezly.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

After many hours spend last night trying to get my root filesystem
autorun when my kernel loads I discovered that sunos.c in fs/partitions
has no support for adding partitions to the list of eligible RAID
members. Before I go and fix the Solaris partition code (it can't work
out what type a partition is at the moment) and add in the
md_autodetect_dev() business, has anyone else already fixed this?

I have a patch at the moment, but it is evil (and tries to add *every*
partition to the RAID list) so I would prefer to do it properly before
releasing it on the world :)

Cheers,

Beezly
