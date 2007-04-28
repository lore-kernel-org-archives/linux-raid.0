From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: XFS on x86_64 Linux Question
Date: Sat, 28 Apr 2007 08:09:53 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0704280809460.7998@p34.internal.lan>
References: <Pine.LNX.4.64.0704280633510.7998@p34.internal.lan>
 <Pine.LNX.4.64.0704280636220.7998@p34.internal.lan>
 <5d96567b0704280457t464e5c3fm81a9e22a5608751@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5d96567b0704280457t464e5c3fm81a9e22a5608751@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: xfs@oss.sgi.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Wow, probably better to stick with 32bit then?

On Sat, 28 Apr 2007, Raz Ben-Jehuda(caro) wrote:

> Justin hello
> I have tested 32 to 64 bit porting of linux raid5 and xfs and LVM
> it worked. though i cannot say I have tested throughly. it was a POC.
>
> On 4/28/07, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>> With correct CC'd address.
>> 
>> 
>> On Sat, 28 Apr 2007, Justin Piszcz wrote:
>> 
>> > Hello--
>> >
>> > Had a quick question, if I re-provision a host with an Intel Core Duo CPU
>> > with x86_64 Linux; I create a software raid array and use the XFS
>> > filesystem-- all in 64bit space...
>> >
>> > If I boot a recovery image such as Knoppix, it will not be able to work 
>> on
>> > the filesystem correct?  I would need a 64bit live CD?
>> >
>> > Does the same apply to software raid?  Can I mount a software raid 
>> created in
>> > a 64bit environment in a 32bit environment?
>> >
>> > Justin.
>> >
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
>
>
> -- 
> Raz
>
