From: Dave Fisher <davef@davefisher.co.uk>
Subject: Re: RAID 10 array won't assemble ... spare ... metadata - Correction Disappointing Report Back
Date: Sat, 18 Apr 2009 21:20:50 +0100
Message-ID: <20090418202050.GD18440@davefisher.co.uk>
References: <20090417141402.GB27042@davefisher.co.uk> <18921.1283.548260.293728@notabene.brown> <20090418201328.GC18440@davefisher.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090418201328.GC18440@davefisher.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Apr 18, 2009 at 09:13:28PM +0100, Dave Fisher wrote:
> But when I ran mdadm -E on each of the partitions the counts were
> competely unchanged, i.e. sd[bcde]4 were still all at 219.
> 
> sda4 was still at 221

The above should have read like so:

But when I ran mdadm -E on each of the partitions the counts were
competely unchanged, i.e. 
  
  sd[bcd]4 were still all at 219
  
  sde4 was still at 218 
  
  sda4 was still at 221

Dave

