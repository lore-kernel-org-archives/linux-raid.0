From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re:
Date: Sun, 5 Apr 2009 07:42:18 -0400
Message-ID: <87f94c370904050442h7bcd0f8fp6d32d942372f7e93@mail.gmail.com>
References: <87f94c370904041738g4ef6221co6c3ace1ebf51dcdf@mail.gmail.com>
	 <20090405050520.KWXV19140.cdptpa-omta03.mail.rr.com@Leslie>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090405050520.KWXV19140.cdptpa-omta03.mail.rr.com@Leslie>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Apr 5, 2009 at 1:05 AM, Lelsie Rhorer <lrhorer@satx.rr.com> wro=
te:
>> Alternate theory - serious fsync performance issue
>>
>> I don't know if it's related, but there is a lot of recent discussio=
n
>> related to fsync causing large delays in ext3. =A0Linus is saying hi=
s
>> highspeed SDD is seeing multisecond delays. =A0He is very frustrated
>> because the SDD should be more or less instantaneous.
>>
>> The current thread is http://markmail.org/message/adiyz3lri6tlueaf
>>
>> In one of the other threads I saw someone saying that in one test th=
ey
>> had a fsync() call take minutes to return. =A0Apparently no one yet
>> fully understands what is going on. =A0Seems like something that cou=
ld
>> in some way be related to what you are seeing.
>
> Well, it could be. =A0I tried flushing the cashes numerous times whil=
e
> testing, but I never could see it made a difference one way or the ot=
her.
>

In a separate thread you said it was reiser and what I have seen
discussed is ext3, so you may be safe from that bug.

As to flushing caches, I don't think that is the same thing.    This
bug specifically impacts fsyncs on a small file while a heavy i/o load
is underway via other processes.  The elevators were being discussed
as part of the problem and fsync triggers different elevator logic
than sync or drop_caches does.

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
