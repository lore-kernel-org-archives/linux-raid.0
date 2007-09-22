From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: syncing remote homes.
Date: Sat, 22 Sep 2007 09:41:40 -0400
Message-ID: <46F51B94.7020009@tmr.com>
References: <215ff4410709210626j604d2b9cm57d6c30987f767d0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <215ff4410709210626j604d2b9cm57d6c30987f767d0@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Fanning <christopher.fanning@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Chris Fanning wrote:
> Hello all,
>
> I hope this isn't a complete off-topic question (or a stupid one either).
>
> We want to setup two desktop servers at two different office branches.
> users will open sessions via nx.
> We dont' have are problem keeping the server instalations in sync and,
> in case of disaster at one office, we can route sessions to the
> remaining server at the other office with DNS (that's the plan
> anayway).
>
> But we're not sure about how to keep the homes in sync between the two
> servers. We've thought about nightly rsync but what else could be
> done?
> One suggestion was to use md with one local disc and another remote
> disc via iSCSI. But I don't think that would work because our network
> connection is not fast. Is that correct?
>
> Any advise please?
>   

You could use the "write-mostly" option for mirroring, along with intent 
bitmaps and some tuning of the parameter "write-behind" to allow gradual 
catchup. If the change rate is less than the bandwidth overall you will 
keep up. And you should look at nbd, which would allow use of dedicated 
files/partitions rather than whole drives. This reduces the hardware 
requirements.

In general, though, unless instant backup is required, I would think 
that manual end-of-session or checkpoint rsync would be more practical. 
And rsync can be run through a compressed ssh tunnel as an option, which 
may reduce the bandwidth needs depending on the data.

My only "advice" is to try and quantify the data volume and look at nbd 
vs. iSCSI to provide the mirror if you go that way.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

