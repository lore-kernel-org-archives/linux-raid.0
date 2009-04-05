From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re:
Date: Sat, 4 Apr 2009 20:38:42 -0400
Message-ID: <87f94c370904041738g4ef6221co6c3ace1ebf51dcdf@mail.gmail.com>
References: <F2C688D6A021E34CB81C0E631EF4C093017A43D1@34093-C4-EVS1.exchange.rackspace.com>
	 <20090405001223.PZXI1944.cdptpa-omta02.mail.rr.com@Leslie>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090405001223.PZXI1944.cdptpa-omta02.mail.rr.com@Leslie>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Apr 4, 2009 at 8:12 PM, Lelsie Rhorer <lrhorer@satx.rr.com> wro=
te:
>> I would try to first run hardware diagnostics. =A0Maybe you will get
>> "lucky" and one or more disks will fail diagnostics, which at least
>> means it will be easy to repair the problem.
>>
>> This could very well be situation where you have a lot of bad blocks
>> that have to get restriped, and parity has to be regenerated. =A0 Ar=
e
>> these the cheap consumer SATA disk drives, or enterprise class disks=
?
>
>
> I don't buy that for a second. =A0First of all, restriping parity can=
 and does
> occur in the background. =A0Secondly, how is it the system writes man=
y
> terrabytes of data post file creation, then chokes on a 0 byte file?
>

Alternate theory - serious fsync performance issue

I don't know if it's related, but there is a lot of recent discussion
related to fsync causing large delays in ext3.  Linus is saying his
highspeed SDD is seeing multisecond delays.  He is very frustrated
because the SDD should be more or less instantaneous.

The current thread is http://markmail.org/message/adiyz3lri6tlueaf

In one of the other threads I saw someone saying that in one test they
had a fsync() call take minutes to return.  Apparently no one yet
fully understands what is going on.  Seems like something that could
in some way be related to what you are seeing.

Greg
--=20
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
=46irst 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.p=
df

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
