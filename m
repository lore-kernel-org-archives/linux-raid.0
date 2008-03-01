From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Understanding bonnie++ results
Date: Sat, 1 Mar 2008 03:05:12 +0100
Message-ID: <20080301020512.GA6657@rap.rap.dk>
References: <1204191989.16924.10.camel@franck-gusty> <20080228190609.GA29262@rap.rap.dk> <1204273482.9381.66.camel@franck-gusty>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1204273482.9381.66.camel@franck-gusty>
Sender: linux-raid-owner@vger.kernel.org
To: Franck Routier <franck.routier@axege.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Feb 29, 2008 at 09:24:42AM +0100, Franck Routier wrote:
> By the way, my server in not really in a production state, and the
> hardware is running, so I might take some time to do sensible tests if
> anyone has ideas of what a good test would be...

I would like you to investigate why random writes are so relatively
slow with raid10,f2. You could run the bonnie+ tests, and then watch
via an iostat how each of the disks are performing, compared to a 
HW RAID10. 

And also see if it matters if the resync has completed or not.

Best regards
keld

> 
> > I like to get such results of comparison between HW and SW raid.
> > How advanced are Adaptec controllers considered these  days? 
> > My thoughts are that SW raid is faster than HW raid, because Neil and the
> > other people here together can develop more sophisticated algorithms,
> > but I would like some hard figures to back up that thought.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
