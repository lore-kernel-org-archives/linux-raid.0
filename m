From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Global spare disks
Date: Wed, 5 Mar 2003 08:49:47 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15973.8059.351337.57384@notabene.cse.unsw.edu.au>
References: <8075D5C3061B9441944E137377645118012E7A@cinshrexc03.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Rechenberg, Andrew on Tuesday March 4
To: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday March 4, ARechenberg@shermanfinancialgroup.com wrote:
> Good day,
> 
> I was wondering if there is any way to assign the same spare disk to
> multiple software RAID arrays.  With hardware controllers you can assign
> a disk as a "global hot spare."  When any disk connected to the
> controller goes south (no matter which array it is in), the global spare
> disk picks up the slack.
> 
> If there is no way to do this with raidtools, could I possibly use mdadm
> to monitor for a failure and then hotadd a disk that is not part of any
> array?

mdadm has explicit support for this.  Look for "spare-group" in the
man page.

NeilBrown

> 
> Thanks for your help.
> 
> Regards,
> Andy.
> 
> Andrew Rechenberg
> Infrastructure Team, Sherman Financial Group.
> arechenberg@shermfin.com
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
