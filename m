From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: very strange (maybe) raid1 testing results
Date: Thu, 31 May 2007 08:48:26 -0400
Message-ID: <465EC41A.3060200@tmr.com>
References: <Pine.LNX.4.64.0705292135200.4266@gheavc.wnzcbav.cig>	<465E346B.7090701@sauce.co.nz>	<Pine.LNX.4.64.0705302154050.4266@gheavc.wnzcbav.cig>	<Pine.LNX.4.64.0705302202230.4266@gheavc.wnzcbav.cig> <18014.20205.440811.634850@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18014.20205.440811.634850@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Jon Nelson <jnelson-linux-raid@jamponi.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Wednesday May 30, jnelson-linux-raid@jamponi.net wrote:
>   
>> On Wed, 30 May 2007, Jon Nelson wrote:
>>
>>     
>>> On Thu, 31 May 2007, Richard Scobie wrote:
>>>
>>>       
>>>> Jon Nelson wrote:
>>>>
>>>>         
>>>>> I am getting 70-80MB/s read rates as reported via dstat, and 60-80MB/s as
>>>>> reported by dd. What I don't understand is why just one disk is being used
>>>>> here, instead of two or more. I tried different versions of metadata, and
>>>>> using a bitmap makes no difference. I created the array with (allowing for
>>>>> variations of bitmap and metadata version):
>>>>>           
>>>> This is normal for md RAID1. What you should find is that for 
>>>> concurrent reads, each read will be serviced by a different disk, 
>>>> until no. of reads = no. of drives.
>>>>         
>>> Alright. To clarify, let's assume some process (like a single-threaded 
>>> webserver) using a raid1 to store content (who knows why, let's just say 
>>> it is), and also assume that the I/O load is 100% reads. Given that the 
>>> server does not fork (or create a thread) for each request, does that 
>>> mean that every single web request is essentially serviced from one 
>>> disk, always? What mechanism determines which disk actually services the 
>>> request?
>>>       
>> It's probably bad form to reply to one's own posts, but I just found
>>
>> static int read_balance(conf_t *conf, r1bio_t *r1_bio)
>>
>> in raid1.c which, if I'm reading the rest of the source correctly, 
>> basically says "pick the disk whose current head position is closest". 
>> This *could* explain the behavior I was seeing. Is that not correct?
>>     
>
> Yes, that is correct.  
> md/raid1 will send a completely sequential read request to just one
> device.  There is not much to be gained by doing anything else.
> md/raid10 in 'far' or 'offset' mode lays the data out differently and
> will issue read requests to all devices and often get better read
> throughput at some cost in write throughput.
>   
The whole "single process" thing may be a distraction rather than a 
solution, as well. I wrote a small program using pthreads which shared 
reads of a file between N threads in 1k blocks, such that each read was 
preceded by a seek. It *seemed* that these were being combined in the 
block layer before being passed on to the md logic, and treated as a 
single read as nearly as I could tell.

I did NOT look at actually disk i/o (didn't care), but rather only at 
the transfer rate from the file to memory, which did not change 
significantly from 1..N threads active, where N was the number of 
mirrors. And RAID-10 did as well with one thread as several.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979


