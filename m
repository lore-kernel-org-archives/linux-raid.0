From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: ***UNCHECKED*** Re: 3-disk RAID5 won't assemble
Date: Sat, 21 Oct 2017 00:37:22 +0100
Message-ID: <8a8ffdc8-4bad-4d99-2fc4-5457556f40f7@youngman.org.uk>
References: <03ddf14a-845d-a6a6-714d-e4bacb77dd7a@ieee.org>
 <59EA5DDB.2020400@youngman.org.uk>
 <9323bcbf-17ba-00d8-159a-38563562d472@ieee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9323bcbf-17ba-00d8-159a-38563562d472@ieee.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Alex Elder <elder@ieee.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20/10/17 23:46, Alex Elder wrote:
> On 10/20/2017 03:34 PM, Wols Lists wrote:
>> On 20/10/17 20:51, Alex Elder wrote:
>>> I have a 3-disk RAID5 with identical drives that won't assemble.
>>>
>>> The event counts on two of them are the same (20592) and one is
>>> quite a bit less (20466).  I do not expect failing hardware.
>>
>> First things first. Have you looked at the raid wiki?
>> https://raid.wiki.kernel.org/index.php/Linux_Raid
> 
> Yes.  And I gathered all the data on the "Asking_for_help" page
> before asking the list.  The information did not solve my problem,
> but it told me enough that I believed I'm probably OK if I take
> the proper steps.  I've attached those files to this message.
> 
>> In particular, take a read of the "When things go wrogn" section. And
>> especially, do a "smartctl -x" - are your drives desktop drives?
> 
> I ran "smartctl -xall" on each and saved the output, but now
> I see that gave an error (so I now ran "smartctl -x" instead).
> 
> They are 2.5" Seagate laptop drives (ST4000LM016).  And:
> "SCT Error Recovery Control command not supported".
> 
> The volume was functioning for a long time (for months anyway)
> prior to the failure.
> 
Okay. That's perfectly normal. The timeout problem is basically because, 
over time, magnetism fades. So the array WILL work perfectly fine to 
start with. But the stuff you wrote on day 1, as time goes on and you 
don't rewrite it, it will fade away (especially if you rewrite the stuff 
next to it).

>>> The problem occurred while I was copying some large files to
>>> the XFS volume on the device, while doing something else that
>>> ate up all my memory.  (It was a long time ago so I that's
>>> about as much detail as I can provide--I assumed the OOM killer
>>> ultimately was to blame, somehow.)
>>
Well, for some reason, you will have asked the drive to *read* some old 
data, and it couldn't. And BOOM linux *thought* the drive was dead 
(that's the timeout problem), kicked the drive, and killed the array.

>> Have you rebooted since then? If that really was the problem, the array
>> should have failed the first time you rebooted.
> 
> Yes, it did fail the first time I booted after the problem
> first occurred.  I didn't have time to look at it when
> it happened and have made do without it until now.  I have
> rebooted many times since the failure, knowing the volume
> would not work until I fixed it.
> 
>>> It *sounds* like the two drives with the same event count should
>>> be enough to recover my volume.  But forcibly doing that is scary
>>> so I'm writing here for encouragement and guidance.
>>>
>>>    {1156} root@meat-> mdadm --stop /dev/md0
>>>    mdadm: stopped /dev/md0
>>>    {1157} root@meat-> mdadm --assemble /dev/md0 /dev/sd[bcd]1
>>>    mdadm: /dev/md0 assembled from 2 drives - not enough to start the
>>> array  while not clean - consider --force.
>>>    {1158} root@meat->
>>
>> Okay. Do NOT force all three drives. Forcing the two with the same event
>> count is safe - you have no redundancy so it's not going to start
>> mucking about with the drives. But first you need to be certain it's not
>> desktop drives and a timeout problem.
>>>
>>> I can provide plenty more information, but thought I'd start by
>>> introducing the problem.
>>>
>>> How should I proceed?  Thanks.
>>>
>> Read the wiki?
> 
> Done.  I can't promise I grokked what was most important.
> 
>> Make sure it's not the timeout problem !!!
> 
> I increased the timeout to 180 and changed the readahead values
> to 1024.  These values do not "stick" across a reboot so I'll
> need to add them to a startup script.
> 
>> Does your array have bitmap enabled?
> 
> It appears so: Internal Bitmap : 8 sectors from superblock
> 
>> Once we're happy that your drives are fine, you can force the two good
>> drives, and then re-add the third. If you have bitmaps enabled, this
>> will bring it quickly up to scratch without needing a full resync.
> 
> That's very reassuring.
> 
>> And once the third is re-added, you need to do a scrub.
>>
>> But it looks like everything is pretty much fine. Recovery *should* be
>> easy (famous last words ...)
> 
> Piece of cake.
> 
>> If you're not sure you're happy, post all the requested diagnostics to
>> the list - preferably inline in your emails - and let an expert take a look.
> 
> Sorry, I attached them...
> 
> I am fairly sure my drives aren't damaged, though I had not done
> the timeout fix previously.

And what's happened looks like the absolutely typical timeout problem.
> 
> I would really appreciate having someone who's been through this
> before glance through the mdadm, mdstat, and smartctl output I've
> provided to make sure I'm not mistaken about the state of things.
> Setting up the RAID was fine; but now that I'm (finally) dealing
> with my first failure I am a bit apprehensive.
> 
> Thanks a lot for your response.
> 
Failing to fix the timeouts is just asking for problems to strike - 
usually some way down the line. Make sure you set that script up to run 
every boot BEFORE you try and fix the array. Then, as I say, just force 
the two good drives and re-add the third. Your array will be back ... 
(and if you really need to re-assure yourself, try it out with overlays 
first).

Cheers,
Wol
