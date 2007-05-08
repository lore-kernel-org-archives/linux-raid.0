From: Brad Campbell <brad@wasp.net.au>
Subject: Re: Swapping out for larger disks
Date: Tue, 08 May 2007 16:43:02 +0400
Message-ID: <46407056.8000607@wasp.net.au>
References: <464055F5.2090108@wasp.net.au> <46406093.2080205@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46406093.2080205@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

David Greaves wrote:

>> I was more wondering about the feasibility of using dd to copy the drive
>> contents to the larger drives (then I could do 5 at a time) and working
>> it from there.

> Err, if you can dd the drives, why can't you create a new array and use xfsdump
> or equivalent? Is downtime due to copying that bad?

I can only do 5 at a time. (10 slots, 5 source - 5 destination).

I'm not worried about the downtime so much as the constant swapping of disks. This way I can do it 
in 2 or 3 blocks at most.


Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
