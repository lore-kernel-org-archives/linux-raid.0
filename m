From: Neil Brown <neilb@suse.de>
Subject: Re: Proper partition type for components with V1.x superblocks?
Date: Thu, 12 Jun 2008 09:52:52 +1000
Message-ID: <18512.25940.653867.623185@notabene.brown>
References: <484F9A3E.7020709@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Peter Rabbitson on Wednesday June 11
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday June 11, rabbit+list@rabbit.us wrote:
> Hello,
> 
> The subject pretty much says it all - it obviously is not 0xFD, since there is 
> nothing to autodetect. Is there some best practice/semi-standard way of 
> marking a raid component partition as such? After reading the specs 0xDA 
> (non-fs data) comes to mind, but I figured I'll ask here.
> 

I (almost) alway make arrays out of whole devices, not partitions, so
I really never thought about this.

I suspect 0xDA is safest and hence best.
I wonder if this should be suggested in the mdadm man page
anywhere.... anyone feel like creating a patch?

NeilBrown
