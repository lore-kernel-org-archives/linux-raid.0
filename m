From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: RAID partition starting sector (... 63?)
Date: Wed, 17 Feb 2010 10:25:06 -0500
Message-ID: <87f94c371002170725w93f42aamec1d64749eeb8be6@mail.gmail.com>
References: <73e903671002170713g397742b8l109773b4c20825ce@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <73e903671002170713g397742b8l109773b4c20825ce@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Feb 17, 2010 at 10:13 AM, Kristleifur Da=F0ason
<kristleifur@gmail.com> wrote:
> Hi,
>
> I remember seeing some discussion on what sector a partition starts
> on. Many programs create partitions that start on sector 63, which
> doesn't really make any intuitive sense to me. I just lost a disk fro=
m
> of a RAID10 array and was thinking I'd try to understand this issue a=
s
> I have to do some disk/block/partition wrangling anyway.
>
> From a discussion from linux-raid titled "Raid 10 LVM JFS Seeking
> performance help", I found the following:
>
> On Mon, Dec 21, 2009 at 12:56 PM, Goswin von Brederlow
> <goswin-v-b@web.de> wrote:
>>
>> Also, on a lower level, make sure your raid does not start on a
>> partition starting at sector 63 (which is still the default in many
>> partitioning progs). That easily results in bad alignment causing 4k
>> chunks to land on 2 sectors. But you need to test that with your
>> specific drive to see if it really is a problem.
>>
>
> Hmm ... In short: Do I want to have a partition start on any
> particular sector? Especially in the case where I want to ...
> - build a RAID10 with partitions (i.e. not with raw devices)
> - using ~256K chunks
> - and have a nice JFS filesystem on top of it.
>
> Starting on sector 64 feels conceptually "prettier" than Sector 63,
> but I can't picture the case where it behaves any different. Except
> perhaps when GRUB expects stuff to begin at sector 63, making a mess
> if we're starting at sector 64. Though it *should* work OK, of course=
=2E
>
> Anyways ... Any tips on a subtle matter most well appreciated.
> Especially tell me if I'm overthinking, please. Thanks.
>
> -- Kristleifur

I believe a better choice is to start at 1 MB regardless of sector
size.  This was initiated by Vista moving to that a few years ago so
you will almost always find hardware, etc.  That assumes your sector
size is still based on a power of two.

If you do get a 4K sector drive be sure it is 1MB aligned (ie. Vista mo=
de).

The only shipping drives I know of are the WD ones and they have a
jumper for sector 63 aligned and 1MB aligned.  In a raid using sector
63 alignment would really make it hard to keep track of things.

There are rumors the future drives may come from the factory
pre-configured for one or the other, so if that turns into reality be
sure to buy the 1MB aligned drives.

Greg
--=20
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
Preservation and Forensic processing of Exchange Repositories White Pap=
er -
<http://www.norcrossgroup.com/forms/whitepapers/tng_whitepaper_fpe.html=
>

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
