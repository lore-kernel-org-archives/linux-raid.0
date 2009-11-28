From: Peter Chacko <peterchacko35@gmail.com>
Subject: Re: Reed Solomon coding based Raid?
Date: Sat, 28 Nov 2009 23:13:38 +0530
Message-ID: <1f808b4a0911280943x4ab781dbq28a11a2e3a77598a@mail.gmail.com>
References: <4B113E90.50904@xs4all.nl> <1259423300.31633.190.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1259423300.31633.190.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Kasper Sandberg <postmaster@metanurb.dk>
Cc: John Hendrikx <hjohn@xs4all.nl>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

symform, a startup create 32 parity stipes of 64 original stripes, and
distribute the fragments in different geographies.

they call it, RAID-96 And apparently reed-solomon coded.

http://www.symform.com/features-benefits.aspx

thanks

On Sat, Nov 28, 2009 at 9:18 PM, Kasper Sandberg <postmaster@metanurb.d=
k> wrote:
> As far as i know, theres not support for this, however, i do believe
> raid6 uses reed-solomon.
>
> On Sat, 2009-11-28 at 16:15 +0100, John Hendrikx wrote:
>> I was wondering if there is support for a raid level where one can
>> choose the redundancy level. =A0Raid 5 allows for one redundant driv=
e,
>> Raid 6 for two, but there's no raid level that would support arbitra=
ry
>> redundancy (even to the point of allowing one to add extra redundanc=
y
>> later on, by simply putting spare drives to immediate use).
>>
>> I'm just a casual Software Raid user, and have been using Raid 6 for=
 a
>> small 8 TB array for a few years now and I realize that there's quit=
e
>> some CPU overhead involved for such redundancy, but for my purposes
>> speed is not a relevant concern (10 MB/sec is enough).
>>
>> --John
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
