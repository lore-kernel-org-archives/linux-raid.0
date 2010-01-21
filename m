From: Asdo <asdo@shiftmail.org>
Subject: Re: Stupid question regarding RAID-1 access pattern
Date: Thu, 21 Jan 2010 09:09:32 +0100
Message-ID: <4B580BBC.2040308@shiftmail.org>
References: <4B44EB58.2090400@northarc.com>
 <20100106213723.GA12318@cthulhu.home.robinhill.me.uk>
 <gu4hbqfzzb8.fsf@tk-cn0001.oulu.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <gu4hbqfzzb8.fsf@tk-cn0001.oulu.fi>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Erno Kuusela wrote:
> Robin Hill <robin@robinhill.me.uk> writes:
>
>   
>> I doubt this would help much really.  If you're reading sequential data
>> then it's pretty much as quick to keep reading as to seek to the next
>> chunk.
>>     
>
> Only if your stripe size is smaller than your bandwidth x seek time.
> Break even stripe size for 100MB/s 10ms disks would be 1 MB, so it
> might work well with 4-10 MB stripes provided the IO stack is up to it?
>   
10ms is the full stroke seek time, I suspect for smaller chunks/seeks 
the time would be *much* shorter...
