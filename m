From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: raid failure question
Date: Mon, 01 Feb 2010 15:19:25 -0500
Message-ID: <4B67374D.1030007@tmr.com>
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
>>     
> Any failure where the disk doesn't actually return an error (within a
> reasonable time).  For example, consumer grade disks often have very
> long retry times - this can mean the array in unusable for a long time
> until the disk eventually fails the read.
>
> If the disk actually returns an error then, AFAIK, the RAID array should
> always be able to recover from it.
>   

The problem is that the admin should be able to set a timeout after 
which recovery takes place even if the drive hasn't returned a bad 
status. And some form of counter could be kept such that after a number 
of these the drive is failed. There is no solution, Neil says the 
timeout should be in the driver, the driver writers say that if it hurts 
md the timeout should be there. Everyone points the finger at some other 
code and says "there."

This is not lazyness or buck passing, Neil feels that md is not the 
place, but putting it elsewhere causes other problems. Until someone 
says "perfect is the enemy of good enough" and puts a timer where it 
will solve the problem, this behavior will continue.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

