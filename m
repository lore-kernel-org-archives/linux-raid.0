From: Moshe Yudkowsky <moshe@pobox.com>
Subject: Re: One Large md or Many Smaller md for Better Performance?
Date: Sun, 20 Jan 2008 21:17:16 -0600
Message-ID: <47940EBC.1070405@pobox.com>
References: <4793AE0E.609@pobox.com> <4793C8C0.3010301@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4793C8C0.3010301@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen wrote:

> One partitionable RAID-10, perhaps, then partition as needed. Read the 
> discussion here about performance of LVM and RAID. I personally don't do 
> LVM unless I know I will have to have great flexibility of configuration 
> and can give up performance to get it. Other report different results, 
> so make up your own mind.

I've used Google to search (again) through the archives of the 
newsgroup, and "performance lvm" turns up relevant discussions back in 
2004 or so, but nothing very recent. Am I missing some other location 
for discussions of this question, or perhaps I'm looking in the wrong 
places? (The Wiki didn't help either.)

-- 
Moshe Yudkowsky * moshe@pobox.com * www.pobox.com/~moshe
"Rumor is information distilled so finely that it can filter through 
anything."
          --  Terry Pratchet, _Feet of Clay_
