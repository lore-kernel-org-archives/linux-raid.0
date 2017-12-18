From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [neilbrown/mdadm] Add udev-md-raid-safe-timeouts.rules (#32)
Date: Mon, 18 Dec 2017 10:32:31 -0500
Message-ID: <a4f35e05-509c-553e-d047-3215a785fe9c@gmail.com>
References: <neilbrown/mdadm/pull/32@github.com>
 <87h8ubsw9g.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87h8ubsw9g.fsf@notabene.neil.brown.name>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neil@brown.name>
Cc: Linux Raid <linux-raid@vger.kernel.org>, jonathan.underwood@gmail.com
List-Id: linux-raid.ids

On 11/03/2017 02:37 AM, NeilBrown wrote:
> 
> This pull request appeared on my github mdadm ... thing.
> 
> I haven't looked in detail.  If someone would like to review it
> or something, that would be nice.

Finally got around to looking at this. I am not hugely familiar with
smartctl, but it looks reasonable to me, especially since they won't be
auto-installed.

Jonathan, please make sure to always CC linux-raid on all mdadm related
patches. Note I prefer patches to git pull requests.

Thanks,
Jes


> Thanks,
> NeilBrown
> 
> On Fri, Nov 03 2017, jonathanunderwood wrote:
> 
>> These udev rules attempt to set a safe kernel controller
>> timeout for disks containing RAID level 1 or higher
>> partitions for commodity disks which do not have SCTERC
>> capability, or do have it but it is disabled.
>>
>> No attempt is made to change the STCERC settings on devices
>> which support it.
>>
>> This attempts to mitigate the problem described here:
>>
>>     https://raid.wiki.kernel.org/index.php/Timeout_Mismatch
>>     http://strugglers.net/~andy/blog/2015/11/09/linux-software-raid-and-drive-timeouts/
>>
>> where the kernel controller may timeout on a read from a
>> disk after the default timeout of 30 seconds and consequently
>> cause mdraid to regard the disk as dead and eject it from the
>> RAID array.
>>
>> The mitigation is to set the timeout to 180 seconds for disks
>> which contain a RAID level 1 or higher partition.
>> You can view, comment on, or merge this pull request online at:
>>
>>   https://github.com/neilbrown/mdadm/pull/32
>>
>> -- Commit Summary --
>>
>>   * Add udev-md-raid-safe-timeouts.rules
>>
>> -- File Changes --
>>
>>     A udev-md-raid-safe-timeouts.rules (61)
>>
>> -- Patch Links --
>>
>> https://github.com/neilbrown/mdadm/pull/32.patch
>> https://github.com/neilbrown/mdadm/pull/32.diff
>>
>> -- 
>> You are receiving this because you are subscribed to this thread.
>> Reply to this email directly or view it on GitHub:
>> https://github.com/neilbrown/mdadm/pull/32

