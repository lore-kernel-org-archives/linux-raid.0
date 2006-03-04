From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: No syncing after crash. Is this a software raid bug?
Date: Sat, 4 Mar 2006 11:10:45 +0100
Message-ID: <dubp35$ts6$1@sea.gmane.org>
References: <20060301124432.GA3591@hactar.lan> <20060301215641.GA27042@hactar.lan> <du6t39$be5$1@sea.gmane.org> <20060303133952.GA2976@redhat.com> <du9ju5$6c5$1@sea.gmane.org> <20060303222619.GB2976@redhat.com> <duahsu$tgn$1@sea.gmane.org> <20060304090112.GC2976@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Heinz Mauelshagen <mauelshagen@redhat.com> wrote:
>> But given the rough scenario above there *are* page-outs first.
> No, a write before another read will happen unless you
> found an unknown bogus case ;)

Well, taking your rough scenario again, assigning it to a swap case
(although it should be the same with a mmap()ing DBMS)...

o page gets dirtied
...probably lots of activity...
o page gets pro-actively synched to swap - handed to mirroring driver
o mirroring driver initiates writes to all mirrors
o write gets through to first mirror
o page content gets changed (page is still dirty)
o second write gets through to other mirror, page gets cleaned
...probably lots of activity...
o low on physical memory, clean page gets re-mapped somewhere else
...probably lots of activity...
o access to the virtual memory page that is now not mapped anymore
  (the one that was previously mapped to our now re-mapped page)
o new mapping is created
o page content is read from swap - handed to mirroring driver
o mirroring driver initiates read to the first mirror
o page contains content before the last change

Okay, the scenario is probably bogus in the way that the access pattern
is quite special:
1. you need an access pattern where a page is accessed very seldom
   (so it constantly runs out of the working set)
2. the race condition with the paging strategy needs to occur while one
   of these seldom accesses (especially while a page modify)


regards
   Mario
-- 
Ho ho ho! I am Santa Claus of Borg. Nice assimilation all together!

