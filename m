From: Neil Brown <neilb@suse.de>
Subject: Re: How do i limit the bandwidth-usage while resyncing on RAID 1?
Date: Fri, 12 Oct 2007 08:27:18 +1000
Message-ID: <18190.41798.212800.167221@notabene.brown>
References: <735D322AED9CD711BE53000476917CD002972B92@NT-SERVER-5>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Rustedt, Florian on Wednesday October 10
Sender: linux-raid-owner@vger.kernel.org
To: "Rustedt, Florian" <florian.rustedt@smartnet.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday October 10, florian.rustedt@smartnet.de wrote:
> Hello List,
> 
> while resyncing, the process takes the whole bandwidth from disk to disk.
> 
> This leads in a VERY unhappy situation, because the system on this raid is
> unpractical slow now, because it has to wait for disk-io.
> 
> How can i tune this? I want somthing like "nice -n 19 dm-mirror" ;)

Are you using MD raid, or DM?

If DM, then it is my understanding that you cannot ratelimit.

If DM, then you already have the answer from a previous post.

NeilBrown
