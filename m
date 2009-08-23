From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: linux disk access when idle
Date: Sun, 23 Aug 2009 14:23:14 -0400
Message-ID: <4A918912.2090602@tmr.com>
References: <20090820163522.GA29215@sewage> <4A8D99D9.2090806@sauce.co.nz> <20090821165935.GA18915@sewage> <4A8ED2FC.2070700@redhat.com> <20090822210443.GA12033@sewage>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090822210443.GA12033@sewage>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Matt Garman wrote:
> On Fri, Aug 21, 2009 at 01:01:48PM -0400, Ric Wheeler wrote:
>   
>> On 08/21/2009 12:59 PM, Matt Garman wrote:
>>     
>>>>> So what I'm trying to figure out is, what is causing the disk
>>>>> access?  It could be any one of:
>>>>>
>>>>>      - Kernel
>>>>>      - RAID subsystem (i.e. md)
>>>>>      - XFS filesystem
>>>>>      - NFS
>>>>>      - Samba
>>>>>      - ???
>>>>>        
>>>>>           
>>>> Are you running smartd? It polls the drives every 30minutes.
>>>>         
>>>    
>>>       
>> I think that you can use blktrace to see who is issuing the IO's
>> that  spin up your drives....
>>     
>
> For five hours today, I ran blktrace on md1 as well as the drives
> that make up md1 (sd[a-d]).  I also enabled block dump via
>
>     echo 1 > /proc/sys/vm/block_dump
>
> Nothing.  Neither block_dump nor blktrace recorded anything on md1
> or sd[abcd].  I caught one instance where the heads parked (I both
> heard them park as well as saw the power meter show the 10 watt
> drop).  They only stayed parked for about five minutes.  Yet neither
> blktrace nor block_dump caught anything.
>
> I'm going to try lm-profiler now (from the laptop-mode-tools
> package), but I have low expectations.
>
> I'm beginning to think that it's not even direct access to the
> drives that cause the heads to unpark, e.g. perhaps even activity on
> my system drive (a compact flash card connected to the PATA port)
> prevents the data drives from parking their heads.
>   

Are you doing regular self test? I'm not sure if non-io connections 
would show using those tools, I just haven't tried them at that level.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"Now we have another quarterback besides Kurt Warner telling us during postgame
interviews that he owes every great thing that happens to him on a football
field to his faith in Jesus. I knew there had to be a reason why the Almighty
included a mute button on my remote."
			-- Arthur Troyer on Tim Tebow (Sports Illustrated)

