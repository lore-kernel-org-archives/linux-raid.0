From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: migrating from RAID5 to RAID10
Date: Wed, 16 Jun 2010 11:54:06 -0400
Message-ID: <4C18F39E.8010600@tmr.com>
References: <20100609151132.GA10082@libra.CS.Berkeley.EDU> <20100611005231.401529c0@natsu> <20100610195851.GA8408@libra.CS.Berkeley.EDU>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100610195851.GA8408@libra.CS.Berkeley.EDU>
Sender: linux-raid-owner@vger.kernel.org
To: Gilad Arnold <arnold@cs.berkeley.edu>
Cc: Roman Mamedov <roman@rm.pp.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Gilad Arnold wrote:
> Thanks for your response, Roman.
>
> On Fri, Jun 11, 2010 at 12:52:30AM +0600, Roman Mamedov wrote:
>   
>>> I have been using RAID5 on a desktop machine using a couple of 500
>>> GB drives.  My original intent was to grow the array by adding more
>>> drives, as the need arises.
>>>       
>> Do you currently run RAID5 with just 2 drives, in degraded mode, or
>> maybe you meant something else?
>>     
>
> No, it is not degraded, it's a clean 2-drive RAID5. I know it doesn't
> make much sense as it is ;-)  the intent was to grow the array later,
> relying on mdadm's grow feature. Right now, I'm guessing that it
> operates like a RAID1 for all practical purposes.
>
>   
I have the feeling that you will then get a lot of read, alter, rewrite 
(RAW) operations on the parity chuck, where you would just get writes of 
a copy for raid{1,10} configuration. The performance of raid5 is poor, 
but with 4-5 drives it gives you some fault tolerance. With even three 
drives the write performance is poor by algorithm, and the read 
performance is poor by implementation (I see no reason for reading at 
the speed of just one drive).

I think your upgrade will fail, but feel free to see if a two drive 
raid5 will start with only one drive, I could be wrong.

If it were me, I would leave the raid up, install the new drive, and 
just copy the data to it. That way you have error tolerance on the 
original data, while your method doesn't. After doing that and reading 
the entire new drive to be sure it's valid, configure the two original 
drives as a degraded three drive raid10. After that's done AND TESTED to 
see that the data are still all valid, then you add the new drive to the 
raid10 and get full operation.

Actually, if it were me I'd have a backup, too. And be damn sure to run 
on a UPS.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

