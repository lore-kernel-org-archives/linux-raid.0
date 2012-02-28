From: Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: Re: Raid5 device hangs in active state
Date: Tue, 28 Feb 2012 15:33:56 -0600
Message-ID: <4F4D4844.3010805@nuclearwinter.com>
References: <4F0A129E.5020706@nuclearwinter.com> <20120109112644.489e4a48@notabene.brown> <4F4D1B33.3010308@nuclearwinter.com> <20120229065206.60d1e2ea@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120229065206.60d1e2ea@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you for taking a look.

I should be able to move the drives to a completely different controller
(and driver) so that will be a good test.

Could NCQ be an issue? IOW, do you think it would be worth disabling NCQ
and re-running this scenario?

--Larkin

On 2/28/2012 1:52 PM, NeilBrown wrote:
> On Tue, 28 Feb 2012 12:21:39 -0600 Larkin Lowrey
<llowrey@nuclearwinter.com>
> wrote:
>
>> I did another sysrq dump and have attached the output.
>
> Thanks. Unfortunately it contains nothing of value - too much has been
> lost. It seems that 'Show State' contains a lot more noise than it used to.
>
> You will need to boot with
> log_buf_len=4M
>
> or something like that.
>
>>
>> Again, 'iostat -dx 1' showed 100% utilization on the LVM which uses
>> /dev/md0 as a pv and /sys/block/md0/md/stripe_cache_active was 29 and
>> that value did not change. There were no error messages in
>> /var/log/messages or 'dmesg'.
>
> The '29' could simply mean that md/raid5 has sent 29 requests down to lower
> levels which have not yet completed.
>>
>> My suspicions lie with md0 since the stripe_cache_active value remains
>> at a fixed non-zero value even though all disks are (or appear to be)
>> idle. Should I be looking elsewhere? This hardware did not exhibit this
>> problem before "upgrading" from Fedora 15 to Fedora 16.
>
> My guess is a problem with one of the drive controllers. Your monthly
'sync'
> puts a much heavier load on them than normal IO does. It is consistently
> sending a bunch of requests to all devices at exactly the same time. This
> could trigger race conditions that normal IO does not.
>
> But that is just a guess. Unfortunately it is very hard to track exactly
> what is going wrong in this sort of case.
>
> I'd suggest shuffling devices so they are on different controllers, or
maybe
> replace a controller. See if you can get the problem to move, and then see
> which controller it stayed with.
>
> NeilBrown
>
>
>>
>> Thank you,
>>
>> --Larkin
>>
>> On 1/8/2012 6:26 PM, NeilBrown wrote:
>>> On Sun, 08 Jan 2012 16:03:10 -0600 Larkin Lowrey
>> <llowrey@nuclearwinter.com>
>>> wrote:
>>>
>>>> Suggestions?
>>>
>>> # echo t > /proc/sysrq-trigger
>>>
>>> and capture that messages that go to 'dmesg'. Post them.
>>>
>>> Hopefully your message ring buffer is big enough to collect the entire
>>> output. If it isn't you might need to boot with
>>> log_buf_len=1M
>>> or similar.
>>>
>>> That should show what process is blocking on what.
>>>
>>> NeilBrown
>>
>

