From: Eric Valette <eric.valette@free.fr>
Subject: Re: Problem with array raid10 array resync on 4.4.0 (keeps reyncing
 each reboot)
Date: Thu, 28 Jan 2016 20:52:22 +0100
Message-ID: <56AA7176.1020508@free.fr>
References: <56A78786.10103@Free.fr> <20160126233133.GB12721@kernel.org>
 <56A870AD.4070400@free.fr> <20160128182522.GB23378@kernel.org>
Reply-To: eric.valette@free.fr
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160128182522.GB23378@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 28/01/2016 19:25, Shaohua Li wrote:
> On Wed, Jan 27, 2016 at 08:24:29AM +0100, Eric Valette wrote:
>> On 27/01/2016 00:31, Shaohua Li wrote:
>>> On Tue, Jan 26, 2016 at 03:49:42PM +0100, Eric Valette wrote:
>>>> Hi,
>>>>
>>>> My raid 10 array (5 disk with one spare) was doing a  resync after an
>>>> upgrade to 4.4.0 from 4.1.15. The resync progress was steady and at the end
>>>> the /proc/mdstat was apparently complete but when rebooting, it started
>>>> resycing over and over. I noticed my dmesg was totally filled with raid10
>>>> conf printout message so it was impossible to trace anything else.
>>>>
>>>> Did a resync test with 3.14.58 (because I knew it had worked for resync
>>>> before and was still available as a boot option)  and the array was
>>>> correctly rebuild.
>>>> Runs fine with 4.1.16 now.
>>>>
>>>> Please CC me as I'm not subscribed.
>>>
>>> Could you please provide more info, like mdadm -D /dev/md0 in v4.4? If you run
>>> a stop/reassemble, does the resync start?
>>
>> I'm not going to retry kernel 4.4.0 on this device as I'm no more confident
>> about raid10 support with this 4.4 version.
>
> Thanks! I know switching to a kernel which is not working well is risky, but
> the info from 4.1 doesn't have enough info for debuging. I also tried to
> reproduce the issue locally, but no success. Did you have any other info which
> could help debugging, for example special config?


If really needed can rebuild a 4.4 kernel and boot it. What do you mean 
by special config? I can send you my kernel .config once rebuild 
(oldconfig from 4.1.16)

But I doubt the problem will show up now that the array is correctly 
rebuild. From memory I used 4.4 kernel without problem for a few days, 
until it decided to resync the array for an unknown reason (standard 
periodic rebuild, disk block read/write error detected, other?).

NB: I have a disk on the array with 56 sectors in error reported by 
smart and noticed read error/SATA reset sequence during first array 
rebuild sequence, but not in any later resync afterward. It did not even 
decided to use the spare disk...

Let me know how I can help debugging further...

-- eric



