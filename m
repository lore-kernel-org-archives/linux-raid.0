From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: What is the proper way to start an array with many failed (but
 good) disks
Date: Thu, 28 Sep 2017 22:19:22 +1000
Message-ID: <46491a11-62c7-73c7-6740-9068bf92efb8@eyal.emu.id.au>
References: <6dba3e31-5c37-5a53-09a5-df8c95991a7a@eyal.emu.id.au>
 <fb6b5a3f-0cd6-6fd5-d2e8-7a47ddd0224e@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fb6b5a3f-0cd6-6fd5-d2e8-7a47ddd0224e@websitemanagers.com.au>
Content-Language: en-AU
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>, list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks Adam,

On 28/09/17 18:32, Adam Goryachev wrote:
> 
> 
> On 28/9/17 17:48, Eyal Lebedinsky wrote:
>> I have a raid6 with 7 disks and the controller had a bad cable connection
>> so 4 disks failed concurrently. They were now marked (S) as expected.
>>
>> I had to power the server down to adjust the cabling then all 7 disks
>> were seen and available, and naturally the array was not started.
>>     md: kicking non-fresh sde1 from array!
>>     md: kicking non-fresh sdf1 from array!
>>     md: kicking non-fresh sdc1 from array!
>>     md: kicking non-fresh sdd1 from array!
>>     md/raid:md127: device sdi1 operational as raid disk 6
>>     md/raid:md127: device sdg1 operational as raid disk 4
>>     md/raid:md127: device sdh1 operational as raid disk 5
>>     md/raid:md127: not enough operational devices (4/7 failed)
>>     md/raid:md127: failed to run raid set.
>>
>> No array in /proc/mdstat.
>>
>> --examin'ing the disks was as expected, sd[c-f]1 have 7139731 events and
>> sd[g-i] have 7140079. There was not much activity on this device then.
>>
>> Q) What is the correct way to re-add all the disks?
>> When I have only one disk fail, I simply --fail/--remove then --re-add it.
>>
>> I re-read the doco and it seems that there is an option for
>>     mdadm --re-add /dev/md127 missing
>>
> I don't think you can re-add them, that would only work if you had enough disks already working to start the array (eg, 1 or 2 failed disks, not 4).

I thought so but needed confirmation.

>> Q) Will this find all the failed members? Can it run on an array that does
>> not yet exist?
>>
>> In this case I needed to somehow assemble the array. Should
>>
>> I ended doing these two:
>>     # mdadm --assemble --force /dev/md127
>> This did not do what I expected, which was to assemble the array with 4
>> spare (or failed) members, ready to be revived.
>> It instead said that the event count was raised on the failed disks to
>> the level of the good ones but did not assemble the array.
>> I thought that changing the event count is bad since it forgets important
>> status information (unless the log has this info).
>>
> This is what --force will do, it will *force* mdadm to accept the devices you have given it, and use them regardless if there is some normal error (like event count differences). It is probably exactly the right thing to have done, given the circumstances, but you should ensure that any hardware issues are fixed first.
> 
> Changing the event count is bad, but the only other option was to re-create the array, which would do a lot more damage than just changing the event count. There will be some data loss and/or corruption, but at least 99% of your data will be good.

I see. I just wondered if the event count can help with the "doing full recovery" thing.

>>     # mdadm --assemble /dev/md127
>> This started the array. No recovery in /proc/mdstat:
>>     md127 : active raid6 sdc1[14] sdi1[8] sdh1[12] sdg1[13] sdf1[7] sde1[9] sdd1[10]
>>           19534425600 blocks super 1.2 level 6, 512k chunk, algorithm 2 [7/7] [UUUUUUU]
>>           bitmap: 0/30 pages [0KB], 65536KB chunk
>>
>> The messages log had:
>>     md127: bitmap file is out of date (7139731 < 7140079) -- forcing full recovery
>>     md127: bitmap file is out of date, doing full recovery
>>     md127: detected capacity change from 0 to 20003251814400
>> and I do not know which of the two command provoked this, I assume the second one.
>>
> You should have date stamps on your logs, and should be able to see a time gap between the logs related to each command. I can't be sure, but expect the first command did assemble the array, but just didn't start it, the second command probably started the array.

I do have stamps (removed to shorten the post) but the two commands were issues close to each other.

>> Q) What does "forcing/doing full recovery" mean?

I am still interested in understanding what this process does.

>> My current controller is unstable so after I install a new controller
>> I will do an array 'check'.
> You should do a raid6 check and then repair to fix any raid6 mismatches between the drives.

I plan to do this after I install a new controller that has a lower risk of dying during the 'check'.
I then run raid6check on any chunks flagged in the log, and if it says it is fixable then I will
let it do so.

> You should also do a fsck on your filesystem to ensure that any corruptions caused by the crash

Have done a 'fsck -f' and it was clean. (while still in single user mode).

> and raid6 repair will be fixed, otherwise one day you will read/write part of the FS, and possibly get a kernel panic due to the bad FS metadata.
> 
> Depending on the data you store on this FS, you might also want to do some analysis of that, some sort of verification if you can, to also ensure that the data is correct/consistent.

Part of my backup schedule includes taking hashes of most files (and I have scripts looking for
differences and making sense of trivial move/rename). Again, this will be done with a healthy controller.

> PS, next time, before you run any commands, you should ask for help first.

Well, I read the doco, then went through the list, then used my experience to make a decision.
I judged the events to be close enough to not lead to a catastrophe.
I could not afford to have this server down for too long.

> Also, before you run any command that will modify the disks, you should use read-only snapshots of the disks (see the RAID wiki for details on how to do that). Even if you do the wrong thing, it will allow you to "start again", which just might save you.

Yes, I know, and would usually do so.
No mismatch messages so far, but I expect to find some.

> Hope that helps.

It does, confirming that my choice of commands was not that bad, and the general recommendations
are very much in line with my plans to do next.

> Regards,
> Adam

cheers

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
