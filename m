From: David Brown <david.brown@hesbynett.no>
Subject: Re: internal write-intent bitmap is horribly slow with RAID10 over 20
 drives
Date: Mon, 5 Jun 2017 12:55:49 +0200
Message-ID: <79ff8fa9-4282-4907-bacf-e9083bac3670@hesbynett.no>
References: <CAGqmV7qRh+_BXAr-qf6vUkiZyzi69E8CiX_vA92tZV2LfDxq_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGqmV7qRh+_BXAr-qf6vUkiZyzi69E8CiX_vA92tZV2LfDxq_A@mail.gmail.com>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 05/06/17 12:06, CoolCold wrote:
> Hello!
> Keep testing the new box and while having not the best sync speed,
> it's not the worst thing I found.
> 
> Doing FIO testing, for RAID10 over 20 10k RPM drives, I have very bad
> performance, like _45_ iops only.
> 

<snip>

> 
> Any advises would be very helpful.
> 

The best advice I can give you is to take a step back, and try to be 
clear what problem you are trying to solve here.  What is this system 
supposed to do?  What are your requirements?  What are your use-cases?

Attempting to optimise the sync speed (or IOPS) of a 20 drive RAID10 set 
is a totally pointless exercise in itself.  At best, it would be a 
torture test for md raid.  There is no system in the world where the 
specifications are "make the fastest 20 drive RAID10 setup" - at least, 
not from a sane IT management.

When you have a clear picture of what you actually /need/, what you 
/want/, what you /have/, and how you want to use it all - /then/, and 
only then, is it time to look at possible RAID setups, filesystem 
arrangements, alternative hardware, etc.  Then you ask for advice on 
this list (or elsewhere - but this list is a good starting point), 
learning about the pros and cons of a variety of possible arrangements.

Once you have collected these ideas, with different balances in 
performance, safety, space efficiency, features, cost, etc., you can 
then test them out and look at benchmarks to see if they will work in 
practice.
