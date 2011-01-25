From: Wolfgang Denk <wd@denx.de>
Subject: Re: Optimize RAID0 for max IOPS?
Date: Tue, 25 Jan 2011 13:45:09 +0100
Message-ID: <20110125124509.D76D6BB0B9@gemini.denx.de>
References: <20110118210112.D13A236C@gemini.denx.de> <4D361F26.3060507@stud.tu-ilmenau.de> <20110119192104.1FA92D30267@gemini.denx.de> <AANLkTikx4g99-Cf_09kEGfF2mmf4Dnuh2A5gTrtKweDy@mail.gmail.com> <alpine.DEB.2.00.1101241024230.14640@p34.internal.lan> <20110124215713.82D75B187@gemini.denx.de> <20110124230314.GA11040@dastard> <20110125083900.4dd65bf2@galadriel2.home> <20110125083643.GE28803@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20110125083643.GE28803@dastard>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Emmanuel Florac <eflorac@intellique.com>, linux-raid@vger.kernel.org, Justin Piszcz <jpiszcz@lucidpixels.com>, xfs@oss.sgi.com
List-Id: linux-raid.ids

Dear Dave Chinner,

In message <20110125083643.GE28803@dastard> you wrote:
>
> Oh, despite $subject being "RAID0" the filesystems being tested are
> on RAID5 and RAID6 with very small chunk sizes on slow SATA drives.
> This is smelling like a case of barrier IOs on software raid on
> cheap storage....

Right. [Any way to avoid these, btw?]  I got side-tracked by the
comments about the new (to me) delaylog mount option to xfs; as the
results were not exactly as exp[ected I though it might be interesting
to report these.

But as the subject says, my current topic is tuning RAID0 to avoid
exactly this type of bottleneck; or rather looking for tunable options
on RAID0

Best regards,

Wolfgang Denk

--
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
PLEASE NOTE: Some Quantum Physics Theories Suggest That When the Con-
sumer Is Not Directly Observing This Product, It May Cease  to  Exist
or Will Exist Only in a Vague and Undetermined State.
