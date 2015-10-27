From: Phil Turmel <philip@turmel.org>
Subject: Re: [UU_] Won't go away
Date: Tue, 27 Oct 2015 08:34:10 -0400
Message-ID: <562F6F42.4070302@turmel.org>
References: <562F6B56.9040901@highpoweredhelp.com>
 <562F6CBE.5020504@turmel.org> <562F6DEA.3010409@highpoweredhelp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <562F6DEA.3010409@highpoweredhelp.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Munger <michael@highpoweredhelp.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Michael,

{Added the list back and fixed the top-posting.  Convention on
kernel.org is to reply-to-all, trim replies, and bottom post or interleave.}

On 10/27/2015 08:28 AM, Michael Munger wrote:
> On 10/27/2015 08:23 AM, Phil Turmel wrote:
>> On 10/27/2015 08:17 AM, Michael Munger wrote:

>>> Personalities : [raid6] [raid5] [raid4]
>>> md0 : active raid5 sdd1[3] sdc1[1] sdb1[0]
>>>       3906764800 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2]
>>> [UU_]
>>>       [>....................]  recovery =  0.1% (2611780/1953382400)
>>> finish=1737.7min speed=18709K/sec
>>>       bitmap: 0/15 pages [0KB], 65536KB chunk

>> What's to fix?  Did you try waiting for the recovery to finish?
>> Creating an array generally isn't instant -- the redundancy has to be
>> computed over the entire array.
>>
>> Now, you might have speed limits that are making it slower than possible
>> (see man md), but multiple hours on big devices is perfectly normal.

> I thought [UU_] indicated a physical drive problem, not logical array
> issue. I'll wait until 2pm when this is supposed to finish and re-check.

I mentioned the speed limits because 20MB/sec is kinda low for modern
drives.  You can probably speed that up.

> It will be GREAT if that's all it was... my being impatient!
>
> PS... lsdrv is a great utility. thanks for making it available on Github.

You're welcome :-)

Phil
