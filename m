From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: RAID 1 not fixing up sector errors?
Date: Thu, 14 Apr 2016 16:56:58 +0200
Message-ID: <20160414145658.GA12918@EIS.leimen.priv>
References: <29813347.d6oRyCVBGp@dag.newtech.fi>
 <20160414142219.GA4783@EIS.leimen.priv>
 <11976887.0JgMgHdD8h@dag.newtech.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <11976887.0JgMgHdD8h@dag.newtech.fi>
Sender: linux-raid-owner@vger.kernel.org
To: Dag Nygren <dag@newtech.fi>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Apr 14, 2016 at 05:43:08PM +0300, Dag Nygren wrote:
> There is a real access and a real error in the log, but no rewrite...

I don't think there are log entries for rewrites.

If the rewrite fails, the disk is either kicked directly, 
or it gets an entry in its bad block log.

You could try mdadm --examine and/or --examine-badblocks on your disks 
and show us the output; also the relevant dmesg entries you've seen so 
maybe someone can tell what's going on.

Regards
Andreas Klauer
