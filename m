From: David Brown <david@westcontrol.com>
Subject: Re: md road-map: 2011
Date: Thu, 17 Feb 2011 11:45:35 +0100
Message-ID: <ijiu99$ill$1@dough.gmane.org>
References: <20110216212751.51a294aa@notabene.brown> <ijgr9p$7v8$1@dough.gmane.org> <20110217083531.3090a348@notabene.brown> <ijhje3$ocd$1@dough.gmane.org> <20110217100139.7520893d@notabene.brown> <ijhq7p$pjv$1@dough.gmane.org> <20110217010455.GA16324@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110217010455.GA16324@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 17/02/2011 02:04, Keld J=F8rn Simonsen wrote:
> On Thu, Feb 17, 2011 at 01:30:49AM +0100, David Brown wrote:
>> On 17/02/11 00:01, NeilBrown wrote:
>>> On Wed, 16 Feb 2011 23:34:43 +0100 David Brown<david.brown@hesbynet=
t.no>
>>> wrote:
>>>
>>>> I thought there was some mechanism for block devices to report bad
>>>> blocks back to the file system, and that file systems tracked bad =
block
>>>> lists.  Modern drives automatically relocate bad blocks (at least,=
 they
>>>> do if they can), but there was a time when they did not and it was=
 up to
>>>> the file system to track these.  Whether that still applies to mod=
ern
>>>> file systems, I do not know - they only file system I have studied=
 in
>>>> low-level detail is FAT16.
>>>
>>> When the block device reports an error the filesystem can certainly=
 record
>>> that information in a bad-block list, and possibly does.
>>>
>>> However I thought you were suggesting a situation where the block d=
evice
>>> could succeed with the request, but knew that area of the device wa=
s of low
>>> quality.
>>
>> I guess that is what I was trying to suggest, though not very clearl=
y.
>>
>>> e.g. IO to a block on a stripe which had one 'bad block'.  The IO s=
hould
>>> succeed, but the data isn't as safe as elsewhere.  It would be nice=
 if we
>>> could tell the filesystem that fact, and if it could make use of it=
=2E But we
>>> currently cannot.   We can say "success" or "failure", but we canno=
t say
>>> "success, but you might not be so lucky next time".
>>>
>>
>> Do filesystems re-try reads when there is a failure?  Could you retu=
rn
>> fail on one read, then success on a re-read, which could be interpre=
ted
>> as "dying, but not yet dead" by the file system?
>
> This should not be a file system feature. The file system is built up=
on
> the raid, and in mirrorred rait types like raid1 and raid10, and also
> other raid types, you cannot be sure which specific drive and sector =
the
> data was read from - it could be one out of many (typically two) plac=
es.
> So the bad blocks of a raid is a feature of the raid and its individu=
al
> drives, not the file system. If it was a property of the file system,
> then the fs should be aware of the underlying raid topology, and know=
 if
> this was a parity block or data block of raid5 or raid6, or which
> mirror instance of a raid1/10 type which  was involved.
>

Thanks for the explanation.

I guess my worry is that if md layer has tracked a bad block on a disk,=
=20
then that stripe will be in a degraded mode.  It's great that it will=20
still work, and it's great that the bad block list means that it is=20
/only/ that stripe that is degraded - not the whole raid.

But I'm hoping there can be some sort of relocation somewhere=20
(ultimately it doesn't matter if it is handled by the file system, or b=
y=20
md for the whole stripe, or by md for just that disk block, or by the=20
disk itself), so that you can get raid protection again for that stripe=
=2E


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
