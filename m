From: Richard Scobie <r.scobie@clear.net.nz>
Subject: Re: How to force rewrite of a smart detected bad block with raid5:
 checkarray?
Date: Thu, 20 Jan 2011 13:30:39 +1300
Message-ID: <4D37822F.1080903@clear.net.nz>
References: <4D372F1C.7080703@clear.net.nz>
 <20110119184914.GA27358@merlins.org> <20110120070133.47eccd10@notabene.brown>
 <20110119205739.GI7117@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20110119205739.GI7117@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: NeilBrown <neilb@suse.de>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



Marc MERLIN wrote:

> So, I went back and read man md, and md.txt in the kernel Documentation
> tree, but I could not find documentation on this:
>   echo 3907029168 > sync_min                                                                                                
>   echo 3907029170 > sync_max 
> 
> and as per my other post, it didn't work for me on 2.6.36
> (echo: write error: Invalid argument)

sync_max is mentioned in md.txt for 2.6.29.1 (currently running here):

   This is a number of sectors at which point a resync/recovery
      process will pause.  When a resync is active, the value can
      only ever be increased, never decreased.  The value of 'max'
      effectively disables the limit.

There is no mention of sync_min.

Regards,

Richard
