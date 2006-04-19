From: Alex Tomas <alex@clusterfs.com>
Subject: Re: linear writes to raid5
Date: Wed, 19 Apr 2006 23:43:29 +0400
Message-ID: <m3acah4ahq.fsf@bzzz.home.net>
References: <m37j60udi8.fsf@bzzz.home.net>
	<17465.43983.345817.253532@cse.unsw.edu.au>
	<m3y7ybrffe.fsf@bzzz.home.net>
	<17468.18087.901186.523228@cse.unsw.edu.au>
	<m3hd4yrdx3.fsf@bzzz.home.net>
	<17474.53696.831154.37427@cse.unsw.edu.au>
	<4444F7A8.7050304@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4444F7A8.7050304@tls.msk.ru> (Michael Tokarev's message of "Tue, 18 Apr 2006 18:28:56 +0400")
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Neil Brown <neilb@suse.de>, Alex Tomas <alex@clusterfs.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> Michael Tokarev (MT) writes:

 MT> Hmm.  So where's the elevator level - before raid level (between e.g.
 MT> a filesystem and md), or after it (between md and physical devices) ?

in the both, because raid5 produces _new_ requests and send them
to elevator again.

 MT> I mean, mergeing bios into larger requests makes alot of sense between
 MT> a filesystem and md levels, but it makes alot less sense to do that
 MT> between md and physical (fsvo "physical" anyway) disks.

i'm not talking about merging small _incoming_ requests. the problem
is that a filesystem sends big requests to raid5 (say, 1MB) and then
raid5 produces ton of small requests (PAGE_SIZE) to handle that 1MB
one. this kills performance.

thanks, Alex
