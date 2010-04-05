From: Mark Knecht <markknecht@gmail.com>
Subject: Re: metadata and / and grub-static
Date: Mon, 5 Apr 2010 09:44:05 -0700
Message-ID: <r2t5bdc1c8b1004050944w1c8c70e7w345a1aa5283b14e5@mail.gmail.com>
References: <u2u5bdc1c8b1004041902l9edc298dg6fb4774aaf8c22a6@mail.gmail.com>
	 <2D.29.28131.56A49BB4@cdptpa-omtalb.mail.rr.com>
	 <r2m5bdc1c8b1004050715q6db273f9o8d1c291a43ebd308@mail.gmail.com>
	 <4BB9F9E4.2060802@anonymous.org.uk>
	 <q2v5bdc1c8b1004050852j98b4b91fne8dea1399892862f@mail.gmail.com>
	 <4BBA105B.2040609@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BBA105B.2040609@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Apr 5, 2010 at 9:31 AM, John Robinson
<john.robinson@anonymous.org.uk> wrote:
> On 05/04/2010 16:52, Mark Knecht wrote:
> [...]
>>
>> John,
>> =C2=A0 Thanks for the summary. It's succinct and covered the info I =
needed
>> this weekend.
>
> In which case, apologies for not answering until Monday afternoon :-)
>

A little struggle on my side is good for the brain. forces me to read
and learn a I try to do. Yeah, frustrating once in awhile, but a good
thing none the less.

>> =C2=A0 One question comes to mind. I'm about to build a Gentoo machi=
ne
>> that will run a number of copies of Windows in VirtualBox VMs. The
>> system will be nice, reliable RAID1 for all of Linux, and then 'fast=
'
>> RAID0 on different drives for the VM data. As there will be nothing
>> involved with booting Linux on this RAID - just the VM data. I assum=
e
>> that there's no problem assembling RAID0 after the boot process has
>> essentially completed, and that this RAID could use any form of
>> metadata?
>
> Yep. You could do this with /home /usr /var too. I expect Gentoo's in=
it
> scripts will run mdadm for you before mounting the other filesystems;=
 the
> other distros generally do.

Yes, I can turn them on if I choose with rc-update add. I haven't done
that yet as I need to do some reading on that also.

Currently I'm focused on understanding benchmarking a bit better -
iozone, bonnie++ - to see what I currently have with my new RAID1.

Cheers,
Mark

>
> Cheers,
>
> John.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
