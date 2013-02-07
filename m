From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance
Date: Thu, 07 Feb 2013 21:41:06 +1100
Message-ID: <511384C2.7020601@websitemanagers.com.au>
References: <51134E43.7090508@websitemanagers.com.au> <5113516C.5080606@aei.mpg.de> <51137DFA.5020406@websitemanagers.com.au> <51138206.5000301@aei.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51138206.5000301@aei.mpg.de>
Sender: linux-raid-owner@vger.kernel.org
To: Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/02/13 21:29, Carsten Aulbert wrote:
> Hi
> 
> On 02/07/2013 11:12 AM, Adam Goryachev wrote:
>> Do you have any information on what your workload is, or how/why these
>> values might help?
> 
> Most of our data servers are exporting data read-only via NFS. It helped
> well on these but more on download servers which allowed us to go from
> 200k 4MB downloads per day to 1M/day while adding new files constantly.
> 
>>
>> You are changing values significantly from the default, and I am
>> cautious that they may cause other issues. Also, someone else has
>> advised to reduce nr_requests rather than increasing it?
>>
> 
> I know, but these larger queues really helped a lot in re-ordering
> requests to better match the hardware underneath - but again, this was
> for hard drives with physical arms and not SSDs

OK, this makes a lot more sense then :) Definitely slowing things
down/making the opportunity to re-order requests should help a lot for
spinning disks... I don't see that helping much at all with SSD's though.

Thanks,
Adam


-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au
