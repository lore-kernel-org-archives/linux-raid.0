From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Raid-5 freezes with large writes... Continues after a more /proc/mdstat???
Date: Thu, 24 Jun 2004 15:27:08 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16602.26156.690023.29084@cse.unsw.edu.au>
References: <20040618130243.21C742074@nw-smtp-05.wineasy.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Alwin Bakkenes on Friday June 18
To: Alwin Bakkenes <alwin.bakkenes@consat.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday June 18, alwin.bakkenes@consat.se wrote:
> Hej, 
> 
> I am using Suse 9.1 and have build (finally) my Raid-5 volume using the
> raidtools. 

Can you tell me what kernel you are running?
Ideally try to reproducing it on a kernel.org kernel, but if that
isn't possible, I at least need to know what kernel.org kernel it is
closest to.

NeilBrown

> 
> When I write large amounts of data to the array (i.e. 50 GB) in a cp or mv
> operation, it always stops in the middle of the copy. It waits. There are no
> kernel messages, no errors, it just waits. 
> 
> The strange part is that after I do a "more /proc/mdstat" my cp/mv operation
> continues. 
> 
> Performance is descent with approx. 20-30MB/s writes and 80MB/s reads. 
> 
> You can see the rest of my setup in a previous post:
> http://marc.theaimsgroup.com/?l=linux-raid&m=108738559332187&w=2
> 
> Has anybody seen this before? 
> 
> Alwin
> 
> P.S. I am using two Maxtor 200GB IDE disks and two identical disks but with
> SATA interface. My box is a Dell 400SC and I run Suse 9.1 with the default
> kernel.
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
