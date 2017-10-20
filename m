From: Alex Elder <elder@ieee.org>
Subject: Re: 3-disk RAID5 won't assemble
Date: Fri, 20 Oct 2017 17:46:33 -0500
Message-ID: <9323bcbf-17ba-00d8-159a-38563562d472@ieee.org>
References: <03ddf14a-845d-a6a6-714d-e4bacb77dd7a@ieee.org>
 <59EA5DDB.2020400@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------B62C6C93446FD4AB53485614"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59EA5DDB.2020400@youngman.org.uk>
Content-Language: en-CA
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------B62C6C93446FD4AB53485614
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On 10/20/2017 03:34 PM, Wols Lists wrote:
> On 20/10/17 20:51, Alex Elder wrote:
>> I have a 3-disk RAID5 with identical drives that won't assemble.
>>
>> The event counts on two of them are the same (20592) and one is
>> quite a bit less (20466).  I do not expect failing hardware.
> 
> First things first. Have you looked at the raid wiki?
> https://raid.wiki.kernel.org/index.php/Linux_Raid

Yes.  And I gathered all the data on the "Asking_for_help" page
before asking the list.  The information did not solve my problem,
but it told me enough that I believed I'm probably OK if I take
the proper steps.  I've attached those files to this message.

> In particular, take a read of the "When things go wrogn" section. And
> especially, do a "smartctl -x" - are your drives desktop drives?

I ran "smartctl -xall" on each and saved the output, but now
I see that gave an error (so I now ran "smartctl -x" instead).

They are 2.5" Seagate laptop drives (ST4000LM016).  And:
"SCT Error Recovery Control command not supported".

The volume was functioning for a long time (for months anyway)
prior to the failure.

>> The problem occurred while I was copying some large files to
>> the XFS volume on the device, while doing something else that
>> ate up all my memory.  (It was a long time ago so I that's
>> about as much detail as I can provide--I assumed the OOM killer
>> ultimately was to blame, somehow.)
> 
> Have you rebooted since then? If that really was the problem, the array
> should have failed the first time you rebooted.

Yes, it did fail the first time I booted after the problem
first occurred.  I didn't have time to look at it when
it happened and have made do without it until now.  I have
rebooted many times since the failure, knowing the volume
would not work until I fixed it.

>> It *sounds* like the two drives with the same event count should
>> be enough to recover my volume.  But forcibly doing that is scary
>> so I'm writing here for encouragement and guidance.
>>
>>   {1156} root@meat-> mdadm --stop /dev/md0
>>   mdadm: stopped /dev/md0
>>   {1157} root@meat-> mdadm --assemble /dev/md0 /dev/sd[bcd]1
>>   mdadm: /dev/md0 assembled from 2 drives - not enough to start the
>> array  while not clean - consider --force.
>>   {1158} root@meat->
> 
> Okay. Do NOT force all three drives. Forcing the two with the same event
> count is safe - you have no redundancy so it's not going to start
> mucking about with the drives. But first you need to be certain it's not
> desktop drives and a timeout problem.
>>
>> I can provide plenty more information, but thought I'd start by
>> introducing the problem.
>>
>> How should I proceed?  Thanks.
>>
> Read the wiki?

Done.  I can't promise I grokked what was most important.

> Make sure it's not the timeout problem !!!

I increased the timeout to 180 and changed the readahead values
to 1024.  These values do not "stick" across a reboot so I'll
need to add them to a startup script.

> Does your array have bitmap enabled?

It appears so: Internal Bitmap : 8 sectors from superblock

> Once we're happy that your drives are fine, you can force the two good
> drives, and then re-add the third. If you have bitmaps enabled, this
> will bring it quickly up to scratch without needing a full resync.

That's very reassuring.

> And once the third is re-added, you need to do a scrub.
> 
> But it looks like everything is pretty much fine. Recovery *should* be
> easy (famous last words ...)

Piece of cake.

> If you're not sure you're happy, post all the requested diagnostics to
> the list - preferably inline in your emails - and let an expert take a look.

Sorry, I attached them...

I am fairly sure my drives aren't damaged, though I had not done
the timeout fix previously.

I would really appreciate having someone who's been through this
before glance through the mdadm, mdstat, and smartctl output I've
provided to make sure I'm not mistaken about the state of things.
Setting up the RAID was fine; but now that I'm (finally) dealing
with my first failure I am a bit apprehensive.

Thanks a lot for your response.

					-Alex

> Cheers,
> Wol
> 


--------------B62C6C93446FD4AB53485614
Content-Type: application/x-compressed-tar;
 name="raid_info.tgz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="raid_info.tgz"

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
AA==
--------------B62C6C93446FD4AB53485614--
