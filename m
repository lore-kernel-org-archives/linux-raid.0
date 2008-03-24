From: Nagy Zoltan <kirk@bteam.hu>
Subject: Re: component growing in raid5
Date: Mon, 24 Mar 2008 17:52:00 +0100
Message-ID: <47E7DC30.3040804@bteam.hu>
References: <47E5FFB8.5030903@bteam.hu> <47E753C4.7030903@rabbit.us> <47E7C609.9000501@bteam.hu> <47E7CBD9.4020900@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47E7CBD9.4020900@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi

> The validity of the snipped arguments depends on how many devices you 
> have at every level:
>
> *) how many nodes there are?
8 nodes
> *) how many disks per node? do all nodes have an equal amount of disks?
currently there are 5 disks at every node, and yes: all nodes have equal 
amount,
but the only thing that matters is that the exported size should be the same
>
> Without additional info I would say this: The problem with using raid5 
> on the top node is that you are stressing your network additionally 
> for every r-m-w-cycle. Also rebuild of this array, especially if you 
> add more leaves will be more and more resource intensive.
after the new nics installed, i except that the rebuild would take about 
8 hours to complete
yes, the r-m-w-cycle would be a pain - but i expect to have much more 
reads than writes
this is truly resource intensive - but the bottleneck would be not at 
the network level, i think it will be
at the root node's south-west connection
i must note that this is my first raid setup ;) and i've not faced with 
rmw-cycle problems before,
and because the use conditions doesn't imply continous random writes - 
we will be happy with this,
next week we will try it out in target conditions - and if something is 
not going as expect, i will
reconsider applying raid10 to it

> In contrast if the top array is RAID10 with 2 chunk copies, you will 
> sacrifice half the space, however your rebuild will utilize only 2 
> drives (one reader one writer).
yes, that clearly could reach better performance, with .5 usable space-ratio
i'm working with relatively low-budget
current ratio is: 4*7/(5*8) = .7

kirk
