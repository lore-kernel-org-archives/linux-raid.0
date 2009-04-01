From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: Adding more drives/saturating the bandwidth
Date: Wed, 1 Apr 2009 12:15:23 -0400
Message-ID: <87f94c370904010915xd1f5e82sca9e92c9a68884cc@mail.gmail.com>
References: <771992.67269.qm@web51307.mail.re2.yahoo.com>
	 <87skks9xg5.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87skks9xg5.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Jon@ehardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 1, 2009 at 11:59 AM, Goswin von Brederlow <goswin-v-b@web.d=
e> wrote:
> Jon Hardcastle <jd_hardcastle@yahoo.com> writes:
>
>> --- On Tue, 31/3/09, Goswin von Brederlow <goswin-v-b@web.de> wrote:
>>> Just see if you can get a decent bandwidth from each disk:
>>>
>>> for i in /dev/sd?; do dd if=3D$i of=3D/dev/null bs=3D1M
>>> count=3D10240 & done
>>> iostat -k 10
>>>
>>>
>>> Halving the bus speed gives you a reasonable low
>>> expectation of how
>>> much data you should be able to pull of the disks. If your
>>> disks can't
>>> even fill half the bus bandwidth you certainly can cope
>>> with more
>>> disks or something is seriously wrong.
>>>
>>> MfG
>>> =A0 =A0 =A0 =A0 Goswin
>
> Perfectly save. Just don't do it the other way around:
>
> !!!WARNING WRITE TEST!!!
>
> for i in /dev/sd?; do dd if=3D/dev/zero of=3D$i bs=3D1M count=3D10240=
 & done
> iostat -k 10

Be advised: on some suse kernels /dev/zero is known to have a
performance bug that would keep it from saturating a PCI-express bus.
I think it was the kernel they had about a year ago (10.3 release).

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
