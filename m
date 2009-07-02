From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: RAID6 questions
Date: Fri, 03 Jul 2009 00:57:56 +0200
Message-ID: <87iqiaofpn.fsf@frosties.localdomain>
References: <2bdd5a4c0907020822s7d136681g23a4e34e13f0be8@mail.gmail.com>
	<871vozox2r.fsf@frosties.localdomain>
	<87f94c370907021513mfd59e27g87e0deac74e4bfb9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87f94c370907021513mfd59e27g87e0deac74e4bfb9@mail.gmail.com>
	(Greg Freemyer's message of "Thu, 2 Jul 2009 18:13:39 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, Marek <mlf.conv@gmail.com>, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Greg Freemyer <greg.freemyer@gmail.com> writes:

> On Thu, Jul 2, 2009 at 12:42 PM, Goswin von Brederlow<goswin-v-b@web.de> wrote:
>> Marek <mlf.conv@gmail.com> writes:
> <snip>
>>> 6. Is it safe to have 20+ partitions for a RAID5,6 system? Most RAID
>>> related sources state that there's a limitation on number of
>>> partitions one can have on SATA drives(AFAIK 16), but i digged out
>>> some information about a recent patch which would remove this
>>> limitation and which according to some other source had also been
>>> accepted into mainline kernel, though I'm not sure about it.
>>> http://thread.gmane.org/gmane.linux.kernel/701825
>>> http://lwn.net/Articles/289927/
>>
>> Should be 15 or unlimited. Look at the major/minor numbers of sda* and
>> sdb. After sda15 there is no space before sdb comes. So unless sda16
>> gets a dynamic major/minor it can't be accessed.
>>
>> It certainly is safe. But it seems stupid as well.
>
> That patch went in 2.6.29 I'm pretty sure.  Not that I have ever
> needed more than 15 partitions on one drive.
>
> And yes major/minor after the first 15 are now dynamic I believe.
>
> Greg

In case someone misunderstands, the "It certainly is safe. But it
seems stupid as well." refers to creating 20+ raid6. Not the
major/minor problem. :)

MfG
        Goswin
