From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Mon, 28 Jan 2013 11:12:08 -0700
Message-ID: <260A980C-51CD-4526-8573-852FB4204DF9@colorremedies.com>
References: <20130127192656.634892005AD@gemini.denx.de> <20130128173704.GA2329@lazy.lzy>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130128173704.GA2329@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: Wolfgang Denk <wd@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Jan 28, 2013, at 10:37 AM, Piergiorgio Sartor <piergiorgio.sartor@nexgo.de> wrote:

> On Sun, Jan 27, 2013 at 08:26:56PM +0100, Wolfgang Denk wrote:
> [...]
>> # cat /sys/block/md0/md/mismatch_cnt
>> 362732152
>> 
>> 
>> This is with mdadm v3.2.6 (mdadm-3.2.6-7.fc18.x86_64); except for the
>> huge values of mismatch_cnt, I see no other indications for errors on
>> the disk drives, RAID arrays or the file systems on top of these.
>> 
>> Is this some known (and hopefully harmless), issue, or must I worry
>> about our data?
> [...]
> 
> 
> Hi Wolfgang,
> 
> I would shamelessly suggest to try "raid6check", in order
> to see if some components have problems.
> 
> The software is somehow buried into "mdadm" source code,
> probably you'll need to take it from the repository.

I'm curious to see what this is and what it reveals. The thing about the count mismatch is it doesn't tell us which is incorrect: data chunk, or parity chunk. For RAID 4/5 of course this is ambiguous. But for RAID 6 it's useful to know the nature of the mismatch. Of course, there is still ambiguity, but it's not 50/50.

This is also why I'm skeptical of "repair" since it assumes the data chunks are valid in the case of a mismatch. How does this work in the case of raid 6, if the two parity chunks agree, but the data chunk mismatches? Is the data chunk still deferred to in a repair?


Chris Murphy