From: Neil Brown <neilb@suse.de>
Subject: Re: where is the spare drive? :-)
Date: Thu, 12 Jan 2006 14:07:01 +1100
Message-ID: <17349.51157.745149.135889@cse.unsw.edu.au>
References: <02a801c60f2a$de619ce0$a400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from JaniD++ on Monday January 2
Sender: linux-raid-owner@vger.kernel.org
To: JaniD++ <djani22@dynamicweb.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday January 2, djani22@dynamicweb.hu wrote:
> 
> 5. The question
> 
> Why shows sdh2 as spare?
> The MD array size is correct.
> And i really can see, the all drive is reading, and sdh2 is *ONLY* writing.
> 

 man mdadm

Towards the end of the CREATE MODE section:

       When creating a RAID5 array, mdadm will automatically create a degraded
       array with an extra spare drive.  This is because  building  the  spare
       into a degraded array is in general faster than resyncing the parity on
       a non-degraded, but not clean, array.  This feature can be  over-ridden
       with the --force option.


I hope this clarifies the situation.

NeilBrown

