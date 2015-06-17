From: Guoqing Jiang <gqJiang@suse.com>
Subject: Re: [PATCH 11/11] Reuse the write_bitmap for update uuid
Date: Wed, 17 Jun 2015 09:53:56 +0800
Message-ID: <5580D334.2030101@suse.com>
References: <1433914934-21195-1-git-send-email-gqjiang@suse.com>	<1433914934-21195-12-git-send-email-gqjiang@suse.com> <20150617095407.14d4ed4e@home.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150617095407.14d4ed4e@home.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, rgoldwyn@suse.de
List-Id: linux-raid.ids

Hi Neil,
>> To handle different situations, it can support updating the uuid of
>> the bitmap. This patch also removes the redundant bitmap_update_uuid.
>>
>> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
>>     
>
> Hi,
>  I have applied all patches except this one to a new branch called
>  'cluster' in git://neil.brown.name/mdadm/
>  I'll merge it with the master branch after the next point release.
>
>  I made a few changes on the way - mostly fixing indenting.  One more
>  significant change is that I made it compile if /usr/include/corosync
>  doesn't exist.
>   
Thanks a lot for that!
>  I didn't apply this change because it doesn't make sense to me.  The
>  format of the bitmap is independent of the metadata used, so using a
>  ->ss method to update t he bitmap doesn't make sense.
>
>  If you can explain what problem you are trying to fix, I'm sure we can
>  find a solution that we are both happy with.
>
>   
There is no problem with previous code, this change just  want to
reuse existed function, and it is ok to drop the patch.

Thanks,
Guoqing
