From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: a couple of mdadm questions
Date: Mon, 8 Sep 2003 17:06:53 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16220.10893.339884.282892@gargle.gargle.HOWL>
References: <1062879895.8172.20.camel@opus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from seth vidal on  September 6
To: seth vidal <skvidal@phy.duke.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On  September 6, skvidal@phy.duke.edu wrote:
> 
> When I do a mdadm -D /dev/md1 it lists out very oddly:
> 
....
> 
> So why does this say - 5 working devices, 2 failed devices and 7 active
> devices?
> 

Because the code in the kernel for keeping these counters up-to-date
is rather fragile and probably broken, but as the counters aren't
actually used for anything (much) I have never bothered fixing it.

> 
> It seems like it should read:
> 7 active devices and 7 working devices.
> In addition, I can't get State: dirty, no-errors to go away.
> 
> I considered recreating this array with:
> 
> mdadm -C /dev/md1 -l 5 -n 7 -c 64 /dev/sdb1 /dev/sdc1 /dev/sdd1 \
> /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1
> 
> but I was a little leery that I might screw something up. There is a lot
> of important data on this array.
> 

You could get mdadm 1.3.0, add some patches from
    http://cgi.cse.unsw.edu.au/~neilb/source/mdadm/patch/applied/
and try
   --assemble --update=summaries

it should fix these counts for you.

> 
> The only other thing that is very odd is that on boot the system always
> claims to fail to start the array, that there are too few drives. But
> then it starts, mounts and the data all looks good. I've compared big
> chunks of the data with md5sum and it's valid. So I think it has
> something to do with the Working Device counts.
> 
> Is that the case?

Probably.  What is the actual message?

NeilBrown
