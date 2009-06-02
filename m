From: Alexander Rietsch <Alexander.Rietsch@hispeed.ch>
Subject: Re: RAID 5 re-add of removed drive? (failed drive replacement)
Date: Tue, 2 Jun 2009 19:13:27 +0200
Message-ID: <5802A2BA-41CF-4036-855D-2DD47D3EF0E0@hispeed.ch>
References: <876585.41936.qm@web51304.mail.re2.yahoo.com>
Mime-Version: 1.0 (Apple Message framework v935.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <876585.41936.qm@web51304.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 02.06.2009, at 16:20, Jon Hardcastle wrote:

>> As always, most problems occur only during critical tasks
>> like
>> enlarging/restoring.
>
> ....
>
> Is this a compelling case for regular
>
> echo check >> /sys/block/mdX/md/sync_action
>
> and/or
>
> echo repair >> /sys/block/mdX/md/sync_action
>
> ??

Yes, indeed! Another lesson learned.
This might have prevented numerous cases in the past when disc surface  
errors occurred while enlarging and resizing a raid array. But all  
those serious incidents where handled perfectly and flawlessly by the  
software raid module. Congrats to all kernel developers here. The raid  
module is far more flexible, error prone and stable than any hardware  
raid solution I've seen so far.

Regards,
Alexander
