From: Neil Brown <neilb@suse.de>
Subject: RE: resync duration ?
Date: Sat, 16 May 2009 07:51:43 +1000
Message-ID: <18957.58351.832772.646681@notabene.brown>
References: <9a9f58b3517ecbc3a076725c671f6cd1.squirrel@neil.brown.name>
	<20090515050801951.MELG9927@cdptpa-omta04.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Leslie Rhorer on Friday May 15
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Friday May 15, lrhorer@satx.rr.com wrote:
> > 
> >   echo check > /sys/block/mdX/md/sync_action.
> > 
> > or "echo repair" to get it to fix anything it finds.
> 
> Thanks.  Those are pretty easy, but it would be nice if they were in the MAN
> page.  Better yet, have you considered adding both as command line options
> for mdadm?

Considered, yes.  But they are very low on my priority list.
I accept patches.
Maybe and option like
   mdadm --syncaction=check /dev/md0

??

NeilBrown
