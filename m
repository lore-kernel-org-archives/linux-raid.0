From: Jeff Garzik <jgarzik@pobox.com>
Subject: Supporting Promise RAID5?
Date: Fri, 12 Sep 2003 13:18:19 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F61FFDB.2010805@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: Arjan van de Ven <arjanv@redhat.com>, neilb@cse.unsw.edu.au
List-Id: linux-raid.ids

So, Promise is interested in working with the open source community to 
support their metadata formats.  Their customers (and I) are pushing 
them to support "Linux RAID" (i.e. md), but they want to be able to 
support their existing customers as well.

This email is basically a two part question:  what's the best for 2.4? 
and 2.6?

For 2.4, it's basically a dead end branch, IMO.  Any 2.6 solution will 
likely be different.  So my suggestion here is to use as much of md's 
raid5 logic as possible.  Either share code -- where possible -- and 
copy code where not.  The idea is to not reinvent a raid5 engine, and 
also leave 2.4 md alone as much as possible.

For 2.6, there are several possibilities.  Arjan (ataraid maintainer) 
has been pondering going through device mapper.  In another email, NeilB 
pointed out to me that 2.6 md is well on its way to supporting pluggable 
metadata formats.

I'm interested in input mainly on 2.6, but welcome suggestions for 2.4 
as well.  One key point that Arjan repeatedly points out to me is that 
md doesn't support partitions (in 2.4 at least, if not 2.6).

	Jeff



