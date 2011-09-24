From: Alex <mysqlstudent@gmail.com>
Subject: Re: Recovering failed array
Date: Sat, 24 Sep 2011 18:39:19 -0400
Message-ID: <CAB1R3shDU37ADtw1wGUTc756wo5hnof2=xrpwYV0O8-yvfD2Hg@mail.gmail.com>
References: <CAB1R3sirkfauftgvNN5Sz9_ZGFaHC7_jZUD5cyRrhfARue08TQ@mail.gmail.com>
	<4E7BAE1E.9020704@turmel.org>
	<CAB1R3sgywmhCxmcVf8CmRt=KMRz7L=QJnkzXLyaPfrgnXmDXwQ@mail.gmail.com>
	<20110923141512.7c48f667@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110923141512.7c48f667@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi guys,

>> Great, thanks for your offer to help. Great program you've written.
>> I've included the output here:
>>
>> # mdadm -E /dev/sd[abcd][12]
>> http://pastebin.com/3JcBjiV6
>>
>> # When I booted into the rescue CD again, it mounted md0 as md127
>> http://pastebin.com/yXnzzL6K
>>
>
> Hmmm ... looks like a bit of a mess. =A0Two devices that should be ac=
tive
> arrays appear to be spares. I suspect you tried to --add them when yo=
u
> shouldn't have. =A0Newer version of mdadm stop you from doing that bu=
t older
> version don't. =A0You only --add a device that you want to be a spare=
, not a
> device that you think is part of the array.

Yes, that is what I did.

> All of the devices think that device 2 (the third in the array) shoul=
d =A0exist
> and =A0be working, but no device claims to be it. =A0Presumably it is=
 /dev/sdc2.
>
>
> You will need to recreate the array.
> i.e.
>
> =A0mdadm -S /dev/md1
> or
> =A0mdadm -S /dev/md125 /dev/md126
>
> or whatever md arrays claim to be holding any of the 4 devices accord=
ing
> to /proc/mdstat.
>
> Then
>
> =A0mdadm -C /dev/md1 -e 1.1 --level 5 -n 4 =A0--chunk 512 --assume-cl=
ean \
> =A0 =A0/dev/sda2 /dev/sdb2 /dev/sdc2 missing
>
> This will just re-write the metadata and assemble the array. =A0It wo=
n't change
> the data.
> Then "fsck -n /dev/md1" and make sure it looks good.
> If it does: good.
> If not, try again with sdd2 in place of sdc2.
>
> Once you are happy that you can see your data, you can add the other =
device
> as a spare and it will rebuild.

Just wanted to let you know that these instructions worked perfectly,
and thanks for all your help.

Any idea how this would have happened in the first place? Somehow two
of the three RAID5 devices failed at once. I've checked all the disks
with the Fujitsu disk scanner, and it found no physical errors. I also
don't think the disks were disturbed in any way while they were
operating.

Thanks again,
Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
