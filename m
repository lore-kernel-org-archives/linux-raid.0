From: Lajber Zoltan <lajbi@lajli.gau.hu>
Subject: Re: RAID0 performance question
Date: Sat, 26 Nov 2005 18:11:50 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0511261810350.1482@lajli.gau.hu>
References: <437E2CB6.2030903@xss.co.at> <17282.22120.327672.720044@cse.unsw.edu.au>
 <20051122220531.GU26862@skl-net.de> <015c01c5f292$57e0e270$0400a8c0@dcccs>
 <5d96567b0511260756t3989df8ep8c98326fc394ca18@mail.gmail.com>
 <01ca01c5f2a3$ab6ebf00$0400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <01ca01c5f2a3$ab6ebf00$0400a8c0@dcccs>
Sender: linux-raid-owner@vger.kernel.org
To: JaniD++ <djani22@dynamicweb.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 26 Nov 2005, JaniD++ wrote:

> Hello, Raz,
>
> Think this is not cpu usage problem. :-)
> The system is divided to 4 cpuset, and each cpuset uses only one disknode.
> (CPU0->nb0, CPU1->nb1, ...)

Seams to be CPU problem. Which kind of NIC do you have?

> CPU2 states:   2.0% user  74.0% system    0.0% nice   3.0% iowait  18.0%
> idle
> CPU3 states:  10.0% user  57.0% system    0.0% nice   5.0% iowait  26.0%

Do you have 4 cpu, or 2 HT cpu?

Bye,
-=Lajbi=----------------------------------------------------------------
 LAJBER Zoltan               Szent Istvan Egyetem,  Informatika Hivatal
 Most of the time, if you think you are in trouble, crank that throttle!
