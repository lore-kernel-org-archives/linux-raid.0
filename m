From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: My md won't assemble even when disks are in clean state.
Date: Sat, 10 Jun 2017 01:07:36 +0100
Message-ID: <2500e212-72da-a136-ee8b-4585b7e786d8@youngman.org.uk>
References: <f8d51bbd-6df7-2ea0-ba6f-8831a2b3e390@gmail.com>
 <da15e516-9d92-9b37-0df4-9a53e56e10ba@websitemanagers.com.au>
 <4353246d-a092-e342-6ef7-091d8e9d77c5@gmail.com>
 <593B0B49.5000102@youngman.org.uk>
 <95dc6a23-167b-4dd8-2436-46428715e14f@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <95dc6a23-167b-4dd8-2436-46428715e14f@gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Ram Ramesh <rramesh2400@gmail.com>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/06/17 00:38, Ram Ramesh wrote:
> On 06/09/2017 03:55 PM, Wols Lists wrote:
>> On 09/06/17 06:44, Ram Ramesh wrote:
>>> Thanks. That did it. I was able to assemble. It assembled degraded and I
>>> --re-added the remaining drives and it accepted without any issue. There
>>> was no rebuild after --re-add which is consistent with the examine
>>> output above that all disks are clean. Did fsck a couple of times for a
>>> good measure and things seem normal now.
>> Just added a note to that effect to the "When things go wrogn" section
>> of the front page of the wiki. Arrays left partially assembled on boot
>> seem such a common problem that a one-liner there seems a fairly good 
>> idea.
>>
> Wol,
> 
>     In fact, that is where I checked first to see if it is safe to stop 
> the array. Since it did not have or I missed it, I got worried. Most of 
> the trouble reported here seem to be created by user error in issuing 
> wrong commands. So, I waited and posted the lengthy details even when my 
> hunch was to stop the array and (re) assemble.
> 
> Thanks for adding the note. Google many times takes us to this page: 
> https://raid.wiki.kernel.org/index.php/Assemble_Run.
> It may be good idea to repeat it there, if this is not too much of 
> redundancy.
> 
Good idea. I've added a section at the start of that page, with a bit 
more detail. I don't want to repeat stuff too often, but that's a good 
place to put it. (Too much repetition, and people can't see the wood for 
the trees :-)

Cheers,
Wol
