From: Steve Cousins <steve.cousins@maine.edu>
Subject: Re: Correct way to create multiple RAID volumes with hot-spare?
Date: Thu, 14 Sep 2006 12:34:35 -0400
Message-ID: <4509849B.3020006@maine.edu>
References: <000001c6d6ba$50819ad0$0e00a8c0@sherlock>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <000001c6d6ba$50819ad0$0e00a8c0@sherlock>
Sender: linux-raid-owner@vger.kernel.org
To: 'Neil Brown' <neilb@suse.de>
Cc: 'Linux RAID Mailing List' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



Ruth Ivimey-Cook wrote:
> Steve, 
> 
> 
>>The recent "Messed up creating new array..." thread has 
>>someone who started by using the whole drives but she now 
>>wants to use partitions because the array is not starting 
>>automatically on boot (I think that was the symptom).  I'm 
>>guessing this is because there is no partigion ID of "fd" 
>>since there isn't even a partition.
> 
> 
> Yes, that's right.

Thanks Ruth.


Neil (or others), what is the recommended way to have the array start up 
if you use whole drives instead of partitions?  Do you put mdadm -A etc. 
in rc.local?

Thanks,

Steve


