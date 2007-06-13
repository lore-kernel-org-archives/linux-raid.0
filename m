From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: Cluster Aware MD Driver
Date: Wed, 13 Jun 2007 15:50:44 -0400
Message-ID: <170fa0d20706131250r75d6be44j6407c649d611969c@mail.gmail.com>
References: <200706140316.57078.hxinwei@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200706140316.57078.hxinwei@gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Xinwei Hu <hxinwei@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Is the goal to have the MD device be directly accessible from all
nodes? This strategy seems flawed in that it speaks to updating MD
superblocks then in-memory Linux data structures across a cluster.
The reality is if we're talking about shared storage the MD management
only needs to happen in one node.  Others can weigh in on this but the
current MD really doesn't want to be cluster-aware.

IMHO, this cluster awareness really doesn't belong in MD/mdadm.  A
high-level cluster management tool should be doing this MD
ownership/coordination work.  The MD ownership can be transferred
accordingly if/when the current owner fails, etc.  But this implies
that the MD is only ever active on one node at any given point in
time.

Mike

On 6/13/07, Xinwei Hu <hxinwei@gmail.com> wrote:
> Hi all,
>
>   Steven Dake proposed a solution* to make MD layer and tools to be cluster
> aware in early 2003. But it seems that no progressing is made since then. I'd
> like to pick this one up again. :)
>
>   So far as I understand, Steven's proposal still applies to currently MD
> implementation mostly, except we have bitmap now. And bitmap can be
> workarounded via set_bitmap_file.
>
>    The problem is that it seems we need a kernel<->userspace interface to sync
> the mddev struct across all nodes, but I don't find out how.
>
>    I'm new to the MD driver, so correct me if I'm wrong. And you suggestions
> are really appreciated.
>
>    Thanks.
>
> * http://osdir.com/ml/raid/2003-01/msg00013.html
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
