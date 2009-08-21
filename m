From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: linux disk access when idle
Date: Fri, 21 Aug 2009 13:01:48 -0400
Message-ID: <4A8ED2FC.2070700@redhat.com>
References: <20090820163522.GA29215@sewage> <4A8D99D9.2090806@sauce.co.nz> <20090821165935.GA18915@sewage>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090821165935.GA18915@sewage>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/21/2009 12:59 PM, Matt Garman wrote:
> On Fri, Aug 21, 2009 at 06:45:45AM +1200, Richard Scobie wrote:
>    
>> Matt Garman wrote:
>>      
>>> So what I'm trying to figure out is, what is causing the disk
>>> access?  It could be any one of:
>>>
>>>      - Kernel
>>>      - RAID subsystem (i.e. md)
>>>      - XFS filesystem
>>>      - NFS
>>>      - Samba
>>>      - ???
>>>        
>> Are you running smartd? It polls the drives every 30minutes.
>>      
> I was running smartd, until I received your post :)
>
> Unfortunately, this does not help keep the heads parked any longer.
>
> Nonetheless, thank you for the hint.
>
> Matt
>
>
>    
I think that you can use blktrace to see who is issuing the IO's that 
spin up your drives....

ric


