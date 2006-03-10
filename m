From: Neil Brown <neilb@suse.de>
Subject: Re: device that *thinks* to be a spare...
Date: Fri, 10 Mar 2006 21:33:31 +1100
Message-ID: <17425.22011.228249.274063@cse.unsw.edu.au>
References: <20060308230200.GA10856@casa.e-den.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Sandro Dentella on Thursday March 9
Sender: linux-raid-owner@vger.kernel.org
To: Sandro Dentella <sandro@e-den.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday March 9, sandro@e-den.it wrote:
> Yersterday i toubled with system crash due to an md device that stopped due
> to an error on a single block (sata controller).

That shouldn't cause a system crash.  Do you have any kernel logs
showing exactly what happened (what the single-block error was etc)?

> 
> Starting from a live rescue cd to analize the situation I found that the
> array thought the good disk was the one had the block failure, so
> that reconstruction arrived at 75% and then restarted (I saw that
> happending).

That is very strange.  Again, logs would be helpful.


> 
> I eliminated the bad disk and the other couldn't start complaining it was a
> spare one (but no one was configured as spare...) so that there where no
> good disk. I had to turn it into a normal /dev/sda disk to be able to start
> the system. 
> 
> My question is if there is a way to convince a device that it is the good
> device w/o destroying the array and how it can happen that an array
> component turns into a spare one.

You can always re-create the array e.g.
  mdadm -C /dev/md -l1 -n2 /dev/sda missing

This does not destroy data.

> 
> What should I have one?

Provided more details in logs :-)

NeilBrown
