From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: possible HighPoint RocketRAID 2720SGL failure
Date: Fri, 22 Sep 2017 18:27:02 +1000
Message-ID: <a0d2e5e4-f5eb-6a73-3e91-250aead0aa3a@eyal.emu.id.au>
References: <73afd1f8-176a-07e9-1024-57692dc96904@eyal.emu.id.au>
 <20170921172019.2067e49b@natsu>
 <CAAMCDefoZFzP2yLu4+_cs90KpqHvwXZKZpAs-xBvJ_s-0Gy4pg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAMCDefoZFzP2yLu4+_cs90KpqHvwXZKZpAs-xBvJ_s-0Gy4pg@mail.gmail.com>
Content-Language: en-AU
Sender: linux-raid-owner@vger.kernel.org
To: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 22/09/17 11:08, Roger Heflin wrote:
> If it is the marvell issue I had before then quit doing smartctl
> commands (disable all smart queries of any sort) as that seemed to
> massively increase the reliablity.  It did not completely fix the
> issues, it just made them happen a lot less often.

I now tried this and it did not help. I stopped all smart access, but running
a md 'check' fails as before (all the disks disappear). Each test fails at a
different address. This time the machine was mostly idle when the check was
running.

I should note that this HighPoint card was running without any problem for
4 years.

Maybe a driver issue? I was running f19 until a few weeks ago, and the failures
all happened after I upgraded to f22 (and now on f26).

Eyal

> good luck, I finally just gave up and quit using marvell controllers.
> 
> On Thu, Sep 21, 2017 at 7:20 AM, Roman Mamedov <rm@romanrm.net> wrote:
>> On Thu, 21 Sep 2017 21:12:36 +1000
>> Eyal Lebedinsky <eyal@eyal.emu.id.au> wrote:
>>
>>> It looks like the controller failed as all 7 disks disappeared together and did not respond
>>> to any i/o or even smart.
>>>
>>> After power off/on things look OK. The raid6 did a very short recovery, then the ext4 fs did
>>> a quick recovery. fsck found no problems.
>>>
>>> I later started a raid 'check' but it failed in less that an hour (out of 10) in the same way.
>>> A day later I tried again and it failed within 15 minutes.
>>>
>>> So far it looks like nothing was lost but I am uncomfortable with this situation.
>>> No surprise here...
>>>
>>> The controller did not log any errors.
>>>
>>> Does this look familiar to anyone?
>>
>> The controller is based on the Marvell 9485 chip and Marvell SATA/RAID
>> controllers seem to have a bad reputation for reliability:
>>
>> https://www.jethrocarr.com/2013/11/24/adventures-in-io-hell/
>> https://www.youtube.com/watch?v=010urq9wY3A
>>
>> I have also faced some CRC errors or disk drop-outs/reconnects on 9123 cards,
>> and in one case all disks (or possibly the controller itself) disappear from
>> the system until reboot on a 88SX7042 based controller.
>>
>> --
>> With respect,
>> Roman

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
