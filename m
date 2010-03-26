From: John Hendrikx <hjohn@xs4all.nl>
Subject: Re: Another take on replacing failed raid drives
Date: Fri, 26 Mar 2010 16:06:51 +0100
Message-ID: <4BACCD8B.8040705@xs4all.nl>
References: <4BAA469B.3050001@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BAA469B.3050001@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Bill Davidsen wrote:
> I stumbled on this description of replacing a drive in a raid array. I 
> share it because different takes on a subject are usesful, and because 
> he had multiple arrays using partitions of the failed drive, rather 
> than a partitioned array.
>
> http://blogs.techrepublic.com.com/opensource/?p=1368
>
I do that too (multiple arrays using partitions).  My reason for that is 
to make future upgrades less painful as it is possible to just copy and 
drop one array at a time. 
