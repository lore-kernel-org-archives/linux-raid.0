From: Oliver Martin <oliver.martin@student.tuwien.ac.at>
Subject: Re: Spontaneous rebuild
Date: Mon, 03 Dec 2007 03:35:51 +0100
Message-ID: <47536B87.2040708@student.tuwien.ac.at>
References: <475230AF.3010100@student.tuwien.ac.at> <18259.15453.811495.461016@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18259.15453.811495.461016@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown schrieb:
> 
> This isn't a resync, it is a data check.  "Dec  2" is the first Sunday
> of the month.  You probably have a crontab entries that does
>    echo check > /sys/block/mdX/md/sync_action
> 
> early on the first Sunday of the month.  I know that Debian does this.
> 
> It is good to do this occasionally to catch sleeping bad blocks.
> 
Duh, thanks for clearing this up. I guess what set the alarm off was
getting what looked like a rebuild to me while stress testing. Yes, I'm
running Debian and I have exactly this entry in my crontab... Perhaps
they should add a short log entry like "starting periodic RAID check" so
that people know there is nothing to worry about.

Or maybe I should just RTFC (read the fine crontab) ;-)

Oliver
