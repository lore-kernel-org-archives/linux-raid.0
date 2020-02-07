From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: Question
Date: Fri, 7 Feb 2020 18:30:29 +0100
Message-ID: <f4146b7d-3ff3-e08d-4dac-1ac9a3de138e@thelounge.net>
References: <CAPpdf5-FJ0cP36pOLm40ESBOws8x5R6XbUOssFFCsY6xtb4_xw@mail.gmail.com>
 <b75c2dc2-d14e-39dc-0c06-7bab53fa7cb8@thelounge.net>
 <CAPpdf5882kxxkK2YrEmWWcM2X=ffcV+YB-GFTck2Qi34ufWE2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPpdf5882kxxkK2YrEmWWcM2X=ffcV+YB-GFTck2Qi34ufWE2g@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: o1bigtenor <o1bigtenor@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



Am 07.02.20 um 17:26 schrieb o1bigtenor:
> On Fri, Feb 7, 2020 at 9:53 AM Reindl Harald <h.reindl@thelounge.net> wrote:
>>
>> Am 07.02.20 um 16:49 schrieb o1bigtenor:
>>> Running a Raid-10 array made up of 4 - 1 TB drives on a debian testing
>>> (11) system.
>>> mdadm - v4.1 - 2018-10-01 is the version being used.
>>>
>>> Some weirdness is happening - - - vis a vis - - - I have one directory
>>> (not small) that has disappeared. I last accessed said directory
>>> (still have the pdf open which is how I could get this information)
>>> 'Last accessed 2020-01-19 6:32 A.M.'  as indicated in the 'Properties'
>>> section of the file in question.
>>>
>>> Has been suggested to me that I make the array read only until this is resolved.
>>> I have space on the the array on a different system to recover this array.
>>> Suggestions on how to do both of the above would be aprreciated
>>
>> directories on a filesystem on top of a RAID don't disappear silently -
>> my bet is a simple drag&drop move or deletion aka PEBCAK
> 
> I checked with bash - - history  and in about 500 items there is no mention of
> such. Looked in log files and can't find anything either. Quite
> puzzling - - - -
> that's why I'm asking here.
> 
> And yes - - - I am aware that all too often I'm the problem. I've
> gotten a lot more
> careful that I was even 5 years ago - - - grin.

if you shave no system error showing any evidence you are wrong here -
even if it would be true witout any errors message you are wrong here
because it's the same as asking if your neighbours dog pissed on your wall

even with a filesystem error you are wrong here and it's impossible that
the raid forget about exactly one folder because that layer don't now
about folders and the FS would puke if a complete area desiapperas at
running fsck - period
