From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: RAID1 & 2.6.9 performance problem
Date: Tue, 18 Jan 2005 14:43:37 +0100
Message-ID: <9dgvb2-0b3.ln1@news.it.uc3m.es>
References: <41EBD827.80701@pipi.ma.cx> <Pine.LNX.4.56.0501171528010.21510@lion.drogon.net> <1105977081.15184.12.camel@linux.local>  <6o6tb2-cj2.ln1@news.it.uc3m.es> <1106054284.17481.21.camel@linux.local>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hans Kristian Rosbach <hk@isphuset.no> wrote:
> On Mon, 2005-01-17 at 17:46, Peter T. Breuer wrote:
> > Interesting. How did you measure latency? Do you have a script you
> > could post?
> 
> It's part of another application we use internally at work. I'll check
> to see wether part of it could be GPL'ed or similar.
> 
> But it is also logical since for two requests in a row to sector and 
> sector +1, it will first seek disk1 and then disk2 when the second 
> request arrives. Atleast it was that way with my hack.

It's not that logical. Readahead on the underlying devices should mean
that sector+1 is read on BOTH drives. I'll tell you below why it
"works".

You want to avoid overlap of the readahead areas. That essentially
means striping underneath in lumps equal to the readahead distance.

> I was pondering maybe doing something like a virtual stripe array, such
> that the data reads are logically alternated between the functioning

It' not worth it - striping is only a means to an end, and the end is
distribution of requests among the participating disks. The stripe
idea works by using alternation in space as a distribution mechanism,
but need you to deliver effectively random seeks to make it work!

You can achieve the same distribution in other ways. The most obvious
is simply rotating the requests round robin, as you are doing. This
doesn't work because different sectors come from different drives -
it means that all the drives will all pull the same areas into their
caches, ditto the drivers for them into the block buffer cache, and
thus you have a bigger lookahead cache plus some parellism and
pipelining ...

Try switching drives every 40KB instead (assuming RA is set to 40 KB).


Peter

