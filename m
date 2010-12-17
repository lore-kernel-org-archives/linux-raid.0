From: "Patrick H." <linux-raid@feystorm.net>
Subject: Re: integrity verification on raid-5?
Date: Fri, 17 Dec 2010 15:20:31 -0700
Message-ID: <4D0BE22F.8000706@feystorm.net>
References: <4D0BD140.6040205@feystorm.net> <20101217212436.GA11425@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101217212436.GA11425@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sent: Fri Dec 17 2010 14:24:37 GMT-0700 (Mountain Standard Time)
From: Robin Hill <robin@robinhill.me.uk>
To: linux-raid@vger.kernel.org
Subject: Re: integrity verification on raid-5?
> On Fri Dec 17, 2010 at 02:08:16PM -0700, Patrick H. wrote:
>
>   
>> Is there a way to do integrity verification on a raid-5 array? I'm 
>> working on building a storage system on SSDs under raid-5 and want to be 
>> able to perform periodic integrity checks. Basically just check the 
>> drives to make sure that they match what the parity drive has.
>> After a bit of googling I saw other people wanting the same thing but 
>> nobody with any result. I dont see why this cant be done, but is there 
>> any tool to do so?
>>     
>
> There's built-in functionality to do this.  To start the check, run:
>     echo check > /sys/block/mdX/md/sync_action
>
> You can check progress by catting /proc/mdstat, and the number of errors
> is reported at the end in /sys/block/mdX/md/mismatch_cnt.  To rewrite
> the parity data for any mismatches, use "repair" instead of "check" in
> the first command.
>
> Currently, there's no easy way to find out what file(s) are affected by
> the mismatches though.
>
>   
The docs say that for both raid 5 & 6 it the repair function simply 
rewrites the parity drive(s). For raid-5 I can understand this as 
there's no way to tell if the data is incorrect, or if the parity is 
incorrect since there's only 1 parity. And while I dont know the details 
of the algorithms involved in raid-6, couldnt you do something like:
Calculate replacement data for both parity drives
If one of the 2 parity drives doesnt match its replacement data
    assume that drive is bad
Else if both parity drives dont match their replacement data
    one of the data drives must be bad
    calculate replacement data for each data drive and find the one that 
doesnt match
    If more than 1 data drive doesnt match its replacement data
       we have multiple-drive failure (could be any combination of 
parity & data drives) and cant determine which ones
Else
    the world is ok

Its probably a heck of a lot more computationally expensive, but it can 
isolate which drive is the bad one. But again, I'm not knowledgeable on 
the the internal details of raid-6 and might just be completely off my 
rocker.

-Patrick

> Cheers,
>     Robin
>   
