From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Raid check didn't fix Current_Pending_Sector, but badblocks -nsv
 did
Date: Tue, 7 Jun 2016 15:57:31 +0200
Message-ID: <20160607135731.GA12550@metamorpher.de>
References: <20160606174113.GI12382@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160606174113.GI12382@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Jun 06, 2016 at 10:41:13AM -0700, Marc MERLIN wrote:
> Howdy, I have a raid 5 where one drive reported this:
> 197 Current_Pending_Sector  0x0032   200   199   000    Old_age   Always -       29

RAID survival depends on healthy drives. This one does not look healthy. 
If the data on your RAID is important, I'd replace this drive. Getting 
this count back down to zero doesn't make it any more trustworthy.
