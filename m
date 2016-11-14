From: Phil Turmel <philip@turmel.org>
Subject: Re: What to do about Offline_Uncorrectable and Pending_Sector in
 RAID1
Date: Mon, 14 Nov 2016 11:10:17 -0500
Message-ID: <daff0d7a-a445-f779-402f-15d0fa6fd7ec@turmel.org>
References: <CAHy4j_7_nRMxOSW16VTAY7bzdW_VMap=Jeb2M0wMiNDoNXcijQ@mail.gmail.com>
 <942ab8be-cd5c-c6d1-d077-cd295b355c0c@youngman.org.uk>
 <CAHy4j_7F=gN9=7mEH-TsdVJR0YFxBzJK98WeJfuwtANoDEy93w@mail.gmail.com>
 <5828D5DA.1070406@youngman.org.uk>
 <CAHy4j_7aC+DCqMRkmK12HPP-wY5kAmLf7W3UG_Nn=TK7ry7ARQ@mail.gmail.com>
 <5829DF1F.7030109@youngman.org.uk>
 <CAHy4j_5gROfjf42VwLxDfmdc6rKYdrWoBy6u2kDefx_Yzzn9kA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHy4j_5gROfjf42VwLxDfmdc6rKYdrWoBy6u2kDefx_Yzzn9kA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bruce Merry <bmerry@gmail.com>, Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/14/2016 11:03 AM, Bruce Merry wrote:
> On 14 November 2016 at 17:58, Wols Lists <antlists@youngman.org.uk> wrote:
>> On 14/11/16 15:52, Bruce Merry wrote:
>>> On 13 November 2016 at 23:06, Wols Lists <antlists@youngman.org.uk> wrote:
>>>>> Sounds like that drive could need replacing. I'd get a new drive and do
>>>>> that as soon as possible - use the --replace option of mdadm - don't
>>>>> fail the old drive and add the new.
>>> Would you mind explaining why I should use --replace instead of taking
>>> out the suspect drive? I guess I lose redundancy for any writes that
>>> occur while the rebuild is happening, but I'd plan to do this with the
>>> filesystem unmounted so there wouldn't be any writes.
>>
>> Because a replace will copy from the old drive to the new, recovering
>> any failures from the rest of the array. A fail-and-add will have to
>> rebuild the entire new array from what's left of the old, stressing the
>> old array much more.

I entirely endorse Anthony's advice on this one.  You are at great risk
of not completing a fail/add resync with the new drive.

> Okay, I can see how for RAID5 that might be a bad thing.
> 
> In my case however, it sounds like --replace will copy everything from
> the failing drive, whereas I'd rather it copied everything from the
> good drive. Same stress on the array, less chance of copying dodgy
> data.

You simply don't have that choice, sorry.  And drives returning dodgy
data is ungodly rare.  The sector checksum algorithms are that good.
You have a URE crisis in your array that is far more significant.

Phil
