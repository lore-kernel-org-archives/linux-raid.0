From: NeilBrown <neilb@suse.de>
Subject: Re: debian software raid1
Date: Sat, 23 Apr 2011 08:12:53 +1000
Message-ID: <20110423081253.0a31b027@notabene.brown>
References: <1303215166.2809.8.camel@valio>
	<4DB1D543.3080400@cdf.toronto.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DB1D543.3080400@cdf.toronto.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Iordan Iordanov <iordan@cdf.toronto.edu>
Cc: b2 <b2@playtime.bg>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 22 Apr 2011 15:21:39 -0400 Iordan Iordanov <iordan@cdf.toronto.edu>
wrote:

> Hello again,
> 
> On 04/19/11 08:12, b2 wrote:
> > sorry for my lame question , just don't know how (if possible) to do it.
> 
> After the 3rd system I had to do this on in the last 3 days, I decided 
> to write a guide myself :). I hope it helps!
> 
> http://iiordanov.blogspot.com/2011/04/how-to-convert-your-single-drive-linux.html



> Create the array. I decided to make a RAID10 array instead of a RAID1 array, 
> which gives me faster sequential reads, but amounts to the same thing in terms
> of data replication. RAID10 with two drives and "n2"

This is not correct.  RAID10-n2 on 2 drives is exactly the same layout and
very nearly the same speed as RAID1 on 2 drives.  (I say 'very nearly' only
because the read-balancing code is a little different and might have slightly
different results).

Or have you measured these two and found an actually difference?  That would
certainly be interesting.

RAID10-f2 will give faster sequential reads at the cost of slower writes.

NeilBrown



> 
> Cheers,
> Iordan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

