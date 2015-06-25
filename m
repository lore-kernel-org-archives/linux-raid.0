From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: mismatch_cnt constantly goes up on ssd+hdd raid1
Date: Thu, 25 Jun 2015 13:30:25 +0800
Message-ID: <558B91F1.4090709@fnarfbargle.com>
References: <3700381434301996@web21o.yandex.ru>	<20150625113335.7bf72b0b@noble> <20150625101959.23981c72@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150625101959.23981c72@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>, NeilBrown <neilb@suse.com>
Cc: tlknv <tlknv@yandex.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 25/06/15 13:19, Roman Mamedov wrote:

> Couldn't this be simply the normal observed effect of using TRIM on SSD?
> After deleting some files, the filesystem issues a discard request, it
> does nothing to the HDDs, but the content of the discared areas on SSD is no
> longer deterministic (or mostly zeroed, as mentioned in the original report).
> So there is now a mismatch between the content of HDDs and SSD, but since it
> is in the area of deleted files, it doesn't affect the system in any way.
>

I get this on a RAID10 with Intel & Samsung SSD's. One supports 
deterministic after TRIM and the other doesn't. Mismatch count is always 
through the roof as a result but there are no other negative effects.

