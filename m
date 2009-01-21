From: eamonn@snifter.org
Subject: Re: differnet UUIDs and no of spares :(
Date: Wed, 21 Jan 2009 11:06:10 -0000 (GMT)
Message-ID: <35147.127.0.0.1.1232535970.squirrel@localhost>
References: <1231954002.17710.13.camel@brandy.snifter.org>
    <496E6C37.9030608@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <496E6C37.9030608@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Eamonn Hamilton <eamonn@snifter.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, January 14, 2009 10:50 pm, Bill Davidsen wrote:
> Eamonn Hamilton wrote:
>
>> Hi Guys,
>>
>>
>> I'm looking at a server with a bunch of disks that had a raid 5 with
>> two spares, however, one of the spares failed, the system then started
>> rebuilding on the other and it crashed during the rebuild.
>>
>> I'm now left in the following situation :
>>
>>
>>
>> for a in a b c d e f g h i; do mdadm --examine --scan /dev/sd${a}; done
>>  ARRAY /dev/md0 level=raid5 num-devices=7
>> UUID=e1e75e8b:f9f387cd:5feed4c5:31c51eb2
>> ARRAY /dev/md0 level=raid5 num-devices=7
>> UUID=e1e75e8b:f9f387cd:5feed4c5:31c51eb2
>> ARRAY /dev/md0 level=raid5 num-devices=7
>> UUID=e1e75e8b:f9f387cd:5feed4c5:31c51eb2
>> ARRAY /dev/md0 level=raid5 num-devices=7
>> UUID=e1e75e8b:f9f387cd:5feed4c5:31c51eb2
>> ARRAY /dev/md0 level=raid5 num-devices=7
>> UUID=e1e75e8b:f9f387cd:5feed4c5:31c51eb2
>> ARRAY /dev/md0 level=raid5 num-devices=7
>> UUID=e1e75e8b:f9f387cd:8d12a2d2:3188faf0
>> spares=1 ARRAY /dev/md0 level=raid5 num-devices=7
>> UUID=e1e75e8b:f9f387cd:8d12a2d2:3188faf0
>> ARRAY /dev/md0 level=raid5 num-devices=7
>> UUID=e1e75e8b:f9f387cd:8d12a2d2:3188faf0
>> spares=1 ARRAY /dev/md0 level=raid5 num-devices=7
>> UUID=e1e75e8b:f9f387cd:8d12a2d2:3188faf0
>>
>>
>>
>> The system complains because of the different uuids, and refuses to
>> recreate the array.
>>
>> Is it basically stuffed, or is there something I can do to recover the
>> 2TB filesystem that's on there ?
>>
>>
>
> What can you tell us about how that happened? When (if ever) was it
> running, how was it created, etc, etc.
>
> You could probably try some things like trying to start it read-only
> using --force, but don't do that yet, if you get it wrong you WILL be
> likely to lose data.
>
> --
> Bill Davidsen <davidsen@tmr.com>
> "Woe unto the statesman who makes war without a reason that will still
> be valid when the war is over..." Otto von Bismark
>
>
>


I don't suppose anybody else has any ideas? I've been holding off
attempting anything in the hope of somebody handing me a silver bullet,
but failing that ... ;)

Given that I still have the logs showing the order in which the drives
were assembled in these various phases, if I force a re-assembly in a
particular order, is there anything in the meta-data which would cause the
array to auto-magically continue where it left off?

Or should I simply take the afore-mentioned silver bullet, bite it and
recreate the whole lot as a RAID6, followed by the usual mad scrabbling
though old hard drives and tapes to try and get most of the content back?

Thanks in advance for any help,
Eamonn

