From: Mattias Wadenstein <maswan@acc.umu.se>
Subject: Re: high throughput storage server?
Date: Mon, 21 Feb 2011 11:04:21 +0100 (MET)
Message-ID: <Pine.GSO.4.64.1102211102490.7398@montezuma.acc.umu.se>
References: <AANLkTik5_Zx98rSbmpgUtG82qtFObANtCcbnn-a7MXcp@mail.gmail.com>
 <Pine.GSO.4.64.1102181429201.7398@montezuma.acc.umu.se> <4D5F0DDA.1000100@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5F0DDA.1000100@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>
Cc: Matt Garman <matthew.garman@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 18 Feb 2011, Joe Landman wrote:

> On 02/18/2011 08:49 AM, Mattias Wadenstein wrote:
> [...]
>> 2U machines with 12 3.5" or 16-24 2.5" hdd slots can be gotten pretty
>> cheaply. Add a quad-gige card if your load can get decent sequential
>> load, or look at fast/ssd 2.5" drives if you are mostly short random
>> reads. Then add as many as you need to sustain the analysis speed you
>> need. The advantage here is that this is really scalable, if you double
>> the number of servers you get at least twice the IO capacity.
>> 
>> Oh, yet another setup I've seen is adding a some (2-4) fast disks to
>> each of the analysis machines and then running a distributed replicated
>> filesystem like hadoop over them.
>
> Ugh ... short-stroking drives or using SSDs?  Quite cost-inefficient for this 
> work.  And given the HPC nature of the problem, its probably a good idea to 
> aim for more cost-efficient.

Or just regular fairly slow sata drives. The advantage being that it is 
really cheap to get to 100-200 spindles this way, so you might not need 
very fast disks. It depends on your IO pattern, but for the LHC data 
analysis this has been showed to be surprisingly fast.

/Mattias Wadenstein
