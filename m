From: Michal Soltys <soltys@ziu.info>
Subject: Re: [PATCH] udev rules: use $tempnode, check for supported types,
 comments
Date: Mon, 19 Sep 2011 09:23:01 +0200
Message-ID: <4E76EDD5.4000605@ziu.info>
References: <1315140164-6991-1-git-send-email-soltys@ziu.info> <1315466708-5431-1-git-send-email-soltys@ziu.info> <1315466708-5431-2-git-send-email-soltys@ziu.info> <20110919131250.070a5002@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110919131250.070a5002@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

W dniu 19.09.2011 05:12, NeilBrown pisze:
> 
> Thanks.
> I've applied this... though I must admit that I don't really like all the
> GOTOs - but that is really the fault of udev I expect.
> 

Yes, well - the alternative is a single bit longer line such as:

ENV{ID_FS_TYPE}!="ddf_raid_member", ENV{ID_FS_TYPE}!="isw_raid_member", ENV{ID_FS_TYPE}!="linux_raid_member", GOTO="md_inc_skip"

I thought the version with one more goto was more readable in the end,
though I also have my doubts about the choice.


> What was the rational for changing
>     ==""
> to
>     !="?*"
> 
> ??
> 

Actually none, just happened during the rewrite (both alternatives 
are functionally identical) - I guess I'm more used to "?*" checks 
for "is / isn't defined", so I didn't pay attention for it to be 
exact like before.

