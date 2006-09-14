From: Neil Brown <neilb@suse.de>
Subject: Re: Correct way to create multiple RAID volumes with hot-spare?
Date: Fri, 15 Sep 2006 02:58:48 +1000
Message-ID: <17673.35400.109037.116836@cse.unsw.edu.au>
References: <000001c6d6ba$50819ad0$0e00a8c0@sherlock>
	<4509849B.3020006@maine.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Steve Cousins on Thursday September 14
Sender: linux-raid-owner@vger.kernel.org
To: Steve Cousins <steve.cousins@maine.edu>
Cc: 'Linux RAID Mailing List' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday September 14, steve.cousins@maine.edu wrote:
> 
> Neil (or others), what is the recommended way to have the array start up 
> if you use whole drives instead of partitions?  Do you put mdadm -A etc. 
> in rc.local?

I would use

	mdadm -As

is rc.local (or /etc/init.d/mdadm or whatever) whether using
partitions or not, but maybe that is just me.
This combined with correct information in mdadm.conf gets it reliably
right every time.

NeilBrown
