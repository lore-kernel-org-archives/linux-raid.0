From: starlight.2012q4@binnacle.cx
Subject: Re: question: no-bitmap RAID1 with off-site drive
Date: Mon, 12 Nov 2012 13:05:54 -0500
Message-ID: <6.2.5.6.2.20121112130511.05dfe610@binnacle.cx>
References: <6.2.5.6.2.20121111163935.05df8b18@binnacle.cx>
 <6.2.5.6.2.20121111170842.05dfe758@binnacle.cx>
 <50A06F9F.3090600@websitemanagers.com.au>
 <6.2.5.6.2.20121112095127.039df8b0@binnacle.cx>
 <CACJz6Qt93zm47+576HSWBv+GGcNKKmz0G7+soAqPSMeBk2KFCg@mail.gmail.com> <CACJz6Qt93zm47+576HSWBv+GGcNKKmz0G7+soAqPSMeBk2KFCg
 @mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACJz6Qt93zm47+576HSWBv+GGcNKKmz0G7+soAqPSMeBk2KFCg
 @mail.gmail.com>
References: <6.2.5.6.2.20121111163935.05df8b18@binnacle.cx>
 <6.2.5.6.2.20121111170842.05dfe758@binnacle.cx>
 <50A06F9F.3090600@websitemanagers.com.au>
 <6.2.5.6.2.20121112095127.039df8b0@binnacle.cx>
 <CACJz6Qt93zm47+576HSWBv+GGcNKKmz0G7+soAqPSMeBk2KFCg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew <drew.kay@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good point but not an issue here.

Have daily offsite cloud incremental backup
in the mix here (i.e. forth drive).

The array does nothing but receive
incremental Bacula archives once a day
in the early AM.  So there's no
moving target data loss potential.


At 09:56 AM 11/12/2012 -0800, Drew wrote:
>> The third drive will never be on site
>> (think about the risk), but that just
>> means that the array will grow from
>> 2->1 and then from 1->2 instead
>> of from 2->3 and 3->2.
>
>I'd argue your risk from a failing disk during
>resync is significantly greater then your risk
>of facility failure during the same window. Not
>sure what drives are pricing where you are but
>adding a forth into the rotation is cheap
>insurance. Two for the array, one syncing, one
>offsite.
>
>Some recent blogs (
>http://storagemojo.com/2010/02/27/does-raid-6-stops-working-in-2
>019/
>for example ) suggest that modern drives will
>encounter unrecoverable read errors approx every
>12TB read. That works out to approx every
>6-12 resyncs based on 1-2TB drives.
>
>
>-- 
>Drew
>--
>To unsubscribe from this list: send the line "unsubscribe 
>linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  
>http://vger.kernel.org/majordomo-info.html

