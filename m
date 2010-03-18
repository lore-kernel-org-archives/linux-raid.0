From: CoolCold <coolthecold@gmail.com>
Subject: Re: How to fix Current_Pending_Sector?
Date: Thu, 18 Mar 2010 20:35:55 +0300
Message-ID: <f19d625d1003181035m396f02a0jf552c1b824a0a689@mail.gmail.com>
References: <4B992054.9020903@stud.tu-ilmenau.de>
	 <C7C3C86F.110A1%groups@email.iain.rauch.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C7C3C86F.110A1%groups@email.iain.rauch.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Iain Rauch <groups@email.iain.rauch.co.uk>
Cc: st0ff@npl.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I had similar issue - there were 5 Currently unreadable (pending)
sectors, 1 Offline uncorrectable sectors then drive was kicked out of
the raid, but readding drive helped - that bad sector gone. Now there
2 pending, 1 uncorrectable, so i gonna fix that two.
My question is - are there any ways to resync array faster? Say if
I'll update bitmaps from current 0.9, fail drive, do dd on sectors,
add drive, will bitmap help to resync not the whole drive, but just
parts which have changed?


On Mon, Mar 15, 2010 at 2:20 PM, Iain Rauch
<groups@email.iain.rauch.co.uk> wrote:
>> Am 11.03.2010 13:25, schrieb Iain Rauch:
>>>> On Thu, Mar 11, 2010 at 3:51 AM, Iain Rauch
>>>> <groups@email.iain.rauch.co.uk> wrote:
>>>>> Smartd emailed me to say I have "1 Currently unreadable (pending)=
 sectors".
>>>>> This actually happened for two disks now.
>>>>>
>>>>> I ran a check and then a repair on my array and they both gave mi=
smatch_cnt
>>>>> of 8.
>>>>>
>>>>> I ran a long self-test on both and they completed without error w=
ith no
>>>>> errors logged. Yet the 'Current_Pending_Sector' is still 1 on bot=
h, and one
>>>>> disk also has a 'UDMA_CRC_Error_Count' of 1.
>>>>>
>>>>> I ran 'hdrecover' on both and they are both telling me "Couldn't =
recover
>>>>> sector 2930277168". It's asking if I want to overwrite it with ze=
ros to fix
>>>>> it, but I would assume this will damage my array?
>>>>>
>>>>> The disk sizes are 1500301910016 bytes and I use 1500250M partiti=
on sizes
>>>>> for the array components. Does that sector fall outside my partit=
ion, and
>>>>> hence would it be safe to overwrite it with zeros?
>>>>>
>>>>> Also, why did I have a mismatch_cnt? I haven't run another check =
since I
>>>>> did
>>>>> the repair, as I wanted to fix the pending sector.
>>>>>
>>>>> BTW, I have a 15 drive RAID6.
>>>>>
>>>>
>>>> If you are running RAID6 and it can read from all but two drives t=
hen
>>>> it should still be able to calculate whatever would match the
>>>> remaining (presumed good) reads to fill the later two drives. =A0R=
ECENT
>>>> kernels will try to write over failed sectors automatically; and o=
nly
>>>> kick the drive if the write fails.
>>>>
>>>> Please provide more information.
>>>>
>>>> Kernel version
>>>> mdadm version
>>>>
>>>> Information about how the source block devices are split up before
>>>> mdadm sees them, and any related messages from the system-log. =A0=
The
>>>> relevant section should be near the end of a dmesg output when you=
've
>>>> just completed a check or repair. =A0Your syslog probably already
>>>> captured the same data and stored it elsewhere.
>>>
>>> I thought doing the repair was supposed to fix the issue, but it di=
dn't seem
>>> to touch it. I wonder if it is outside what md sees, but then how w=
ould it
>>> have been noticed as unreadable? And is it coincidence that both dr=
ives have
>>> the same unreadable sector?
>>>
>>> root@Edna:/home/iain# uname -a
>>> Linux Edna 2.6.28-16-server #57-Ubuntu SMP Wed Nov 11 10:34:04 UTC =
2009
>>> x86_64 GNU/Linux
>>> root@Edna:/home/iain# mdadm -V
>>> mdadm - v2.6.9 - 10th March 2009
>>>
>>> I paste the end of messages below. There's loads of that all the wa=
y through
>>> doing the repair so I'm not sure how to filter out the useful bits.
>>>
>>>
>>> Iain
>>> [...]
>>
>> Hi Iain,
>>
>> the "Current_pending_sectors" is a smart attribute which gets
>> incremented during online (reading and writing sectors) AND offline
>> drive scanning (also called SMART Data Collection), when the drive f=
inds
>> out a sector cannot be correctly read at the first try (offline data
>> collection) or after applying various error-correction techniques.
>> The easiest way to get rid of this problem: dd a sector of zeros ont=
o
>> the broken sector, then fail the drive, re-add it. =A0Now wait until=
 the
>> resync is done.
>> The fact I'm not sure about is: should one fail and re-add both driv=
es
>> at once? =A0As by that the redundancy would get lost...
>>
>> Speaking about redundancy: our rule of thumb (at xtivate.de) is "eac=
h 4
>> drives need one redundancy" - so a redundancy of 2 with 15 drives is
>> kind of playing with your luck...
>>
>> Good luck,
>> Stefan
>
> Well, I failed one of the drives and allowed 'hdrecover' to overwrite=
 the
> unreadable sector, but it still couldn't fix it. Here's its report:
>
> Wiping sector 2930277168...
> Checking sector is now readable...
> I still couldn't read the sector!
> I'm sorry, but even writing to the sector hasn't fixed it - there's n=
othing
> more I can do!
> Summary:
> =A01 bad sectors found
> =A0of those 0 were recovered
> =A0and 1 could not be recovered and were destroyed causing data loss
>
> The 'Current_Pending_Sector' was still 1, so I dd zero onto the whole=
 drive.
> I guess I could have just done part of it, but I suppose that verifie=
d the
> whole drive 'works'. It only took ~5 hours. Funnily enough this did f=
ix the
> Current_pending_sectors count back to zero. Still no error reports in=
 the
> SMART data, and 'Reallocated_Event_Count' didn't go up - shouldn't th=
at have
> gone up to one?
>
> I re-partitoned and added it to the array and it rebuilt fine in ~12 =
hours.
>
> Repeated the process with the second drive and everything's back to n=
ormal.
>
> The drive that had the 'UDMA_CRC_Error_Count' still says 1, but I don=
't
> think I need to worry about that?
>
> In direct reply to Stefan:
>
> I think you meant to dd zeros onto the drive /after/ failing it - wou=
ld have
> caused corruption otherwise?
>
> I definitely think it made sense to do one at a time.
>
> One parity drive for every four seems a bit extreme, especially when =
you
> have a backup (which I don't). I'm fairly happy with 15 drives in RAI=
D 6. I
> had 24 drives before, and that did give me a few problems :p Just nee=
d to
> keep the drives healthy. (Array scrubs, SMART tests etc).
>
>
> Iain
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
