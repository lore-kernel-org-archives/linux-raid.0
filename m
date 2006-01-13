From: Lajber Zoltan <lajbi@lajli.gau.hu>
Subject: Re: md faster than h/w?
Date: Fri, 13 Jan 2006 22:08:55 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0601132207450.2052@lajli.gau.hu>
References: <dq7jii$n1c$1@sea.gmane.org> <20060113144640.GA10566@lug.udel.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060113144640.GA10566@lug.udel.edu>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

On Fri, 13 Jan 2006, Ross Vandegrift wrote:

> > Is 180MB/s-200MB/s a reasonable number for this h/w?
> > What numbers do other people see on their raid0 h/w?
> > Any other advice/comments?

> So my feeling is that your numbers are fairly close to where they
> should be.  Faster procs, SCSI, and a better RAID card.  However, I'd
> also try RAID1 if you're mostly interested in read speed.  Remember

Qlogic state max 190MB/s for their pci-x FC HBA, which came from 2Gbps FC
and pci-x.

Bye,
-=Lajbi=----------------------------------------------------------------
 LAJBER Zoltan               Szent Istvan Egyetem,  Informatika Hivatal
 Most of the time, if you think you are in trouble, crank that throttle!
