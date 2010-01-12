From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: raid failure question
Date: Tue, 12 Jan 2010 06:08:15 -0600
Message-ID: <4B4C662F.3010305@gmail.com>
References: <1263232840.8962.193.camel@kije> <20100111205332.GA24486@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100111205332.GA24486@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Robin Hill wrote:
> On Mon Jan 11, 2010 at 11:00:40AM -0700, Tim Bock wrote:
> 
>> Hello,
>>
>> Excluding the obvious multi-disk or bus failures, can anyone describe
>> what type of disk failure a raid cannot detect/recover from?
>>
>> I have had two disk failures over the last three months, and in spite of
>> having a hot spare, manual intervention was required each time to make
>> the raid usable again.  I'm just not sure if I'm not setting something
>> up right, or if there is some other issue.
>>
>> Thanks for any comments or suggestions.
>>
> Any failure where the disk doesn't actually return an error (within a
> reasonable time).  For example, consumer grade disks often have very
> long retry times - this can mean the array in unusable for a long time
> until the disk eventually fails the read.
> 
> If the disk actually returns an error then, AFAIK, the RAID array should
> always be able to recover from it.
> 
> Cheers,
>     Robin

The OS will time the disk out at about 30 seconds if it does not 
answer, and then the disk gets treated as "BAD".

On fiber channel this is a fairly common type of failure, if something 
fails in the fabric such that the disk can no longer talk to the machine.
