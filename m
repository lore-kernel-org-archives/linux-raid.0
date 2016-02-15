From: o1bigtenor <o1bigtenor@gmail.com>
Subject: Re: Questions
Date: Mon, 15 Feb 2016 06:12:08 -0600
Message-ID: <CAPpdf59u6SPD3=sv1XmKR09jzt6OL8TYLgOj==i3G4775fqbhg@mail.gmail.com>
References: <CAPpdf58O+=Re1dBe1Rmj7jb=9iJkMZZBuZfEX4S32wMXcv6uWQ@mail.gmail.com>
	<56C0200B.8030606@websitemanagers.com.au>
	<CAPpdf5_JBJB19B7wG5iuTt_aDZ6Zg0=kgQJtR_REU9JfDN1CxA@mail.gmail.com>
	<AE031459-5104-437F-8353-ACF855CB02CC@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AE031459-5104-437F-8353-ACF855CB02CC@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Greetings

On Sun, Feb 14, 2016 at 6:24 AM, Adam Goryachev
<mailinglists@websitemanagers.com.au> wrote:
> On 14 February 2016 10:53:48 pm AEDT, o1bigtenor <o1bigtenor@gmail.com> wrote:
>>On Sun, Feb 14, 2016 at 12:34 AM, Adam Goryachev
>><mailinglists@websitemanagers.com.au> wrote:
>>>
>>>
>>> On 14/02/2016 15:28, o1bigtenor wrote:
>>>>
>>>> Greetings
>>>>
>>>> My raid 10 array was the subject of a number of exchanges on this
>>>> board a few months ago.
>>>> With the generous assistance of members here things were
>>reestablished
>>>> and have been working well. Today I had a VirtualBox VM crater and
>>in
>>>> the process cause other system issues. In process to clear the mess
>>a
>>>> number of hard stops (shutting the system off using the button on
>>the
>>>> case) were used. In rebooting I found that one of the drives in the
>>>> array is no longer responding issuing a number of clicks in the boot
>>>> up process with nothing else happening. Even though it is a RAID 10
>>>> array the array is no longer mounted nor available. I have removed
>>the
>>>> faulty drive already. I have an appropriately sized drive available
>>>> that I could place into the machine.
>>>>
>>>> 1. should I reformat the drive (to be placed into the machine)?
>>>> 2. what sequence of commands should I be using for this new drive to
>>>> be included into the array?
>>>> 3. what sequence of commands should I use to remount the array?
>>>
>>>
>>> First thing I would suggest is to let everyone know the status of the
>>> current array, and how to get it working.
>>>
>>> Can you send the output of cat /proc/mdstat and mdadm --misc --detail
>>> /dev/md?
>>
>># cat /proc/mdstat
>>Personalities : [raid10]
>>md0 : active (auto-read-only) raid10 sde1[5] sdc1[4] sdb1[3]
>>     1953518592 blocks super 1.2 512K chunks 2 near-copies [4/3] [U_UU]
>>
>>unused devices: <none>
>>
>># mdadm --misc --detail /dev/md
>>mdadm: /dev/md does not appear to be an md device
>>
>># mdadm --misc --detail /dev/md/0
>>/dev/md/0:
>>        Version : 1.2
>>  Creation Time : Mon Mar  5 08:26:28 2012
>>     Raid Level : raid10
>>     Array Size : 1953518592 (1863.02 GiB 2000.40 GB)
>>  Used Dev Size : 976759296 (931.51 GiB 1000.20 GB)
>>   Raid Devices : 4
>>  Total Devices : 3
>>    Persistence : Superblock is persistent
>>
>>    Update Time : Sat Feb 13 17:21:51 2016
>>          State : clean, degraded
>> Active Devices : 3
>>Working Devices : 3
>> Failed Devices : 0
>>  Spare Devices : 0
>>
>>         Layout : near=2
>>     Chunk Size : 512K
>>
>>           Name : debianbase:0  (local to host debianbase)
>>           UUID : 79baaa2f:0aa2b9fa:18e2ea6b:6e2846b3
>>         Events : 60241
>>
>>    Number   Major   Minor   RaidDevice State
>>       5       8       65        0      active sync set-A   /dev/sde1
>>       2       0        0        2      removed
>>       4       8       33        2      active sync set-A   /dev/sdc1
>>       3       8       17        3      active sync set-B   /dev/sdb1
>>
>>
>>>
>>> Assuming the existing array is in a "normal" status, albeit degraded,
>>then
>>> it should be pretty simple to just partition the new drive to match
>>the
>>> other members, and then simply add the new partition to the array
>>(mdadm
>>> --manage /dev/md? --add /dev/sdxy)
>>
>>Drive I wish to use for replacement has had some use.
>>Should I be reformatting it?
>>
>
> Not needed, the resync will overwrite the content. You just need to partition it the same as the other drive members.
>
> Then you can simply add it to the array and it will sync.
>
> Also, you should have access to your stay content already if you just mount it (assuming it contains a file system )
>
> Let us know if you need any more help.
>

Thank you to Mr Adam for his assistance!

Installed the drive and, with a wait time for results, everything is
working very well.

I am looking at replacing ALL the drives in the array so that I can
reduce the likelihood of these kind of issues for a longer period than
a few months.

Would you be able to tell me what steps should I be taking to replace
the entire array?

Should I replace the drives one at a time (sort of just like I did
this time) using the same commands?

If so is there an easy way of mounting the array?

Regards

Dee
