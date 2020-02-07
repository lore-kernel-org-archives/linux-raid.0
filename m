From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Question
Date: Fri, 7 Feb 2020 19:27:02 +0000
Message-ID: <5E3DBA06.6000706@youngman.org.uk>
References: <CAPpdf5-FJ0cP36pOLm40ESBOws8x5R6XbUOssFFCsY6xtb4_xw@mail.gmail.com>
 <b75c2dc2-d14e-39dc-0c06-7bab53fa7cb8@thelounge.net>
 <CAPpdf5882kxxkK2YrEmWWcM2X=ffcV+YB-GFTck2Qi34ufWE2g@mail.gmail.com>
 <f4146b7d-3ff3-e08d-4dac-1ac9a3de138e@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f4146b7d-3ff3-e08d-4dac-1ac9a3de138e@thelounge.net>
Sender: linux-raid-owner@vger.kernel.org
To: Reindl Harald <h.reindl@thelounge.net>, o1bigtenor <o1bigtenor@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/02/20 17:30, Reindl Harald wrote:
> 
> 
> Am 07.02.20 um 17:26 schrieb o1bigtenor:
>> On Fri, Feb 7, 2020 at 9:53 AM Reindl Harald <h.reindl@thelounge.net> wrote:
>>>
>>> Am 07.02.20 um 16:49 schrieb o1bigtenor:
>>>> Running a Raid-10 array made up of 4 - 1 TB drives on a debian testing
>>>> (11) system.
>>>> mdadm - v4.1 - 2018-10-01 is the version being used.
>>>>
>>>> Some weirdness is happening - - - vis a vis - - - I have one directory
>>>> (not small) that has disappeared. I last accessed said directory
>>>> (still have the pdf open which is how I could get this information)
>>>> 'Last accessed 2020-01-19 6:32 A.M.'  as indicated in the 'Properties'
>>>> section of the file in question.
>>>>
>>>> Has been suggested to me that I make the array read only until this is resolved.
>>>> I have space on the the array on a different system to recover this array.
>>>> Suggestions on how to do both of the above would be aprreciated
>>>
>>> directories on a filesystem on top of a RAID don't disappear silently -
>>> my bet is a simple drag&drop move or deletion aka PEBCAK
>>
>> I checked with bash - - history  and in about 500 items there is no mention of
>> such. Looked in log files and can't find anything either. Quite
>> puzzling - - - -
>> that's why I'm asking here.
>>
>> And yes - - - I am aware that all too often I'm the problem. I've
>> gotten a lot more
>> careful that I was even 5 years ago - - - grin.
> 
> if you shave no system error showing any evidence you are wrong here -
> even if it would be true witout any errors message you are wrong here
> because it's the same as asking if your neighbours dog pissed on your wall

You're rather dogmatic here ... I agree if you're not getting any system
error then it's unlikely to be the system. Though I would ask has the OP
run a check on the array itself - if raid thinks the array is good then
it probably is.
> 
> even with a filesystem error you are wrong here and it's impossible that
> the raid forget about exactly one folder because that layer don't now
> about folders and the FS would puke if a complete area desiapperas at
> running fsck - period
> 
And here you are TOO dogmatic. Ever heard of file corruption where PART
of a file gets corrupted? And it's nothing to do with the disk. The
entry for the directory could easily have got damaged.

And I've had the exact same thing seem to happen where PEBKAC is highly
unlikely - unless pebkac can magically acquire root permissions on a
system where I almost never do things as root ... and like it seems the
OP, drag and drop is very unlikely also as I rarely have a file manager
running.

So yes, I know exactly where the OP is coming from, and I'm just as
confused as to what's going on, especially as I deliberately change
permissions on stuff that's meant to be write-once to make sure that it
*IS* write-once.

Cheers,
Wol
