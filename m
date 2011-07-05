From: "Tyler J. Wagner" <tyler@tolaris.com>
Subject: Re: advanced partition format, mdadm, and raw disks
Date: Tue, 05 Jul 2011 06:24:13 +0100
Message-ID: <1309843453.2865.8.camel@baal>
References: <1309796133.2766.63.camel@baal>
	 <20110705103030.401066f6@notabene.brown> <1309840130.2865.5.camel@baal>
	 <20110705145641.3f8eb3db@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110705145641.3f8eb3db@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2011-07-05 at 14:56 +1000, NeilBrown wrote:
> 0.90 has data at the start and metadata at the end on a 64k aligned boundary.
> So if the partition is 4K aligned, everything else will be too.

OK, that's clear. Thanks very much for your help. It's a rare project
that the main developer helps users so directly. I appreciate it.

I'm rebuilding the array using aligned partitions and 1.2 metadata
anyway. It'll be easier to maintain, especially if I later have to
replace a drive.

Regards,
Tyler

-- 
"It is an interesting and demonstrable fact, that all children are atheists
and were religion not inculcated into their minds, they would remain so."
   -- Ernestine Rose

