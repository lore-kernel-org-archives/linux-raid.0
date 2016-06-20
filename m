From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: unbalanced RAID5 / performance issues
Date: Mon, 20 Jun 2016 11:26:00 +0200
Message-ID: <20160620092600.GA3549@metamorpher.de>
References: <57678E2D.9080705@websitemanagers.com.au>
 <20160620104455.Horde.Cu9WNhgOSFjDC3hgl4ZCm01@www3.nde.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160620104455.Horde.Cu9WNhgOSFjDC3hgl4ZCm01@www3.nde.ag>
Sender: linux-raid-owner@vger.kernel.org
To: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Cc: Adam Goryachev <adam@websitemanagers.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jun 20, 2016 at 10:44:55AM +0200, Jens-U. Mozdzen wrote:
> Zitat von Adam Goryachev <adam@websitemanagers.com.au>:
> > As you can see, sdc (and sda) has a much higher utilisation compared  
> > to all the other drives, but we can see the actual reads/writes are  
> > similar across all drives.
> 
> looking at those numbers, it might not be the (effective) utilization  
> that's higher, but the time the SSDs spend handling the requests.

sdc also happens to be the last drive in your array. 

When creating raid5, the initial sync will overwrite this drive completely. 
Are you using fstrim / discard? Without TRIM this SSD might consider itself 
completely full and take longer for new writes.

Also there might be an issue with SF-2281 controller used by these SSDs:

http://www.anandtech.com/show/5508/intel-ssd-520-review-cherryville-brings-reliability-to-sandforce/7

They state that even after TRIM the SSD does not return to 
its prime condition...

Apart from that, double check that your partitions are aligned. 
This is usually the case but may be a huge problem if overlooked.

Regards
Andreas Klauer
