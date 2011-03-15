From: Bas van Schaik <bas@tuxes.nl>
Subject: Re: Doing 'echo repair > /sys/devices/virtual/block/md?/md/sync_action'
 does not result in mismatch_cnt of 0 on RAID-6?
Date: Tue, 15 Mar 2011 13:43:01 +0000
Message-ID: <4D7F6CE5.4010303@tuxes.nl>
References: <4D7F4DF3.7010804@tuxes.nl> <20110315121351.GA7190@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110315121351.GA7190@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 15/03/11 12:13, Robin Hill wrote:
> On Tue Mar 15, 2011 at 11:30:59AM +0000, Bas van Schaik wrote:
>> All,
>>
>> I'm seeing a non-zero mismatch_cnt (in fact, it's 1704) on my RAID-6
>> array consisting of 8 devices on kernel 2.6.38. After replacing some
>> hardware, I decided to trigger a MD repair by issuing:
>>   echo repair > /sys/devices/virtual/block/md5/md/sync_action
>>
>> Directly after issuing this command, the mismatch_cnt is reset to 0 and
>> MD starts checking the array. However, the mismatch_cnt increases during
>> this check - resulting in exactly the same count as seen before.
>> Shouldn't 'repair' yield a zero mismatch_cnt? I think I have seen
>> 'repair' work on other RAID-6 arrays?
>>
> The mismatch_cnt is incremented during repair to indicate how many
> errors were repaired. If you want to be certain though, you'd need to
> re-run 'check' afterwards.
Sorry about that - I was sure the mismatch_cnt was reset after a repair
on a different machine, but apparently I was wrong. The 'check' is
running right now, I hope you are right! If not, of course I'll let you
know.

My other question is still standing:
> Furthermore, theoretically it should be possible to indicate which
> device in the RAID-6 array contains the inconsistent data, or am I
> mistaking? If so, that would certainly be a nice feature to see
> implemented, as it would help diagnosing problems.
Am I indeed correct in thinking this?

Thanks,

  Bas
