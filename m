From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: What to do about Offline_Uncorrectable and Pending_Sector in
 RAID1
Date: Tue, 15 Nov 2016 18:49:34 +0000
Message-ID: <f5c66009-956a-6751-2164-3249b8454208@youngman.org.uk>
References: <CAHy4j_7_nRMxOSW16VTAY7bzdW_VMap=Jeb2M0wMiNDoNXcijQ@mail.gmail.com>
 <942ab8be-cd5c-c6d1-d077-cd295b355c0c@youngman.org.uk>
 <CAHy4j_7F=gN9=7mEH-TsdVJR0YFxBzJK98WeJfuwtANoDEy93w@mail.gmail.com>
 <5828D5DA.1070406@youngman.org.uk>
 <CAHy4j_7aC+DCqMRkmK12HPP-wY5kAmLf7W3UG_Nn=TK7ry7ARQ@mail.gmail.com>
 <5829DF1F.7030109@youngman.org.uk>
 <008001d23f6c$298b5260$7ca1f720$@wnsdev.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <008001d23f6c$298b5260$7ca1f720$@wnsdev.com>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Sangas <pete@wnsdev.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 15/11/16 18:14, Peter Sangas wrote:
> Hi Wol,
>
>
> -----Original Message-----
> From: Wols Lists [mailto:antlists@youngman.org.uk]
> Sent: Monday, November 14, 2016 7:58 AM
> To: Bruce Merry
> Cc: linux-raid@vger.kernel.org
> Subject: Re: What to do about Offline_Uncorrectable and Pending_Sector in RAID1
>
> On 14/11/16 15:52, Bruce Merry wrote:
>> On 13 November 2016 at 23:06, Wols Lists <antlists@youngman.org.uk> wrote:
>>>> Sounds like that drive could need replacing. I'd get a new drive
>>>> and do that as soon as possible - use the --replace option of mdadm
>>>> - don't fail the old drive and add the new.
>> Would you mind explaining why I should use --replace instead of taking
>> out the suspect drive? I guess I lose redundancy for any writes that
>> occur while the rebuild is happening, but I'd plan to do this with the
>> filesystem unmounted so there wouldn't be any writes.
>
>> Because a replace will copy from the old drive to the new, recovering any failures from the rest of the array. A fail-and-add will have to rebuild the entire new array >from what's left of the old, stressing the old array much more.
>
>> Okay, in your case, it probably won't make an awful lot of difference, but it does make you vulnerable to problems on the "good" drive. To alter your wording >slightly, you lose redundancy for writes AND READS that occur while the array is rebuilding. It's just good practice (and I point it out because --replace is new and >not well known at present).
>
>> Cheers,
>> Wol
>
> With respect to the --replace switch and "replacing a failed drive" documented on the wiki here:
> https://raid.wiki.kernel.org/index.php/Replacing_a_failed_drive  Can you clear a few things up for me ?
>
> 1. If I just want to replace a working drive in a RAID1 and the array is still redundant I can
> issue the following command as in your example:
>
> mdadm /dev/mdN [--fail /dev/sdx1] --remove /dev/sdx1 --add /dev/sdy1
>
> which fails and removes sdx1 and replaces it with sdy1.
>
> Question1. How is this different from first doing a fail/remove on sdx1, physically replacing sdx1 with sdy1 and doing an add on sdy1?
>
Not really different at all. It's just that you (obviously) can't do the 
remove and add in the same command if you physically swap the drive in 
the middle.

But I bang on a bit about having access to spare port to stick a drive 
on, so I've assumed you can have both the old and the new drive 
physically (and logically) in the system at the same time.
>
> 2. If one of the drives as an error in a RAID1 and gets kicked out of the array and the array loses redundancy the wiki has the following example:
>
> mdmad /dev/mdN --re-add /dev/sdX1
> mdadm /dev/mdN --add /dev/sdY1 --replace /dev/sdX1 --with /dev/sdY1
>
> Question2.   Is this point here to first try and re-add sdX1 with the "--re-add" (first line above) and if that fails do a replace (second line above)?
>
Correct. You've lost redundancy, and (you NEED a bitmap here) the idea 
is to get sdX1 back in to the array to restore redundancy before you 
copy its contents to sdY1.

You need the bitmap because, without it, a re-add becomes a normal add, 
and it's not only a waste of time, it adds stress to the array and 
increases your chances of a total failure.
>
> Thanks,
> Peter
>
Cheers,
Wol
