From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: migrating raid-1 to different drive geometry ?
Date: Tue, 25 Jan 2005 11:53:00 +1100
Message-ID: <16885.39020.65563.568853@cse.unsw.edu.au>
References: <20050124145910.GC29766@kaneda>
	<16885.31484.125772.316987@cse.unsw.edu.au>
	<ct447m$l90$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Robin Bowes on Tuesday January 25
Sender: linux-raid-owner@vger.kernel.org
To: Robin Bowes <robin-lists@robinbowes.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday January 25, robin-lists@robinbowes.com wrote:
> Neil Brown wrote:
> > If you are using a recent 2.6 kernel and mdadm 1.8.0, you can grow the
> > array with
> >    mdadm --grow /dev/mdX --size=max
> 
> Neil,
> 
> Is this just for RAID1? OR will it work for RAID5 too?

 --grow --size=max

should work for raid 1,5,6.

NeilBrown
