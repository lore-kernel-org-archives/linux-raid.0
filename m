From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: How to configure 36 disks ?
Date: Mon, 23 Mar 2009 12:45:23 -0400
Message-ID: <87f94c370903230945k66a804a0iefbb76dd9c93fc16@mail.gmail.com>
References: <49C7AC2C.9090307@tmr.com>
	 <174852.24274.qm@web51309.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-aio@kvack.org>
In-Reply-To: <174852.24274.qm@web51309.mail.re2.yahoo.com>
Sender: owner-linux-aio@kvack.org
To: Jon@ehardcastle.com
Cc: Raz <raziebe@gmail.com>, Bill Davidsen <davidsen@tmr.com>, linux-fsdevel@vger.kernel.org, Linux RAID Mailing List <linux-raid@vger.kernel.org>, linux-xfs@oss.sgi.com, linux-aio@kvack.org, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Mar 23, 2009 at 12:02 PM, Jon Hardcastle
<jd_hardcastle@yahoo.com> wrote:
>
> I'd like to understand how you even go attaching that many devices to a s=
ystem.. I am 'comparatively' new to this.. and have a 6 raid5 system.. not =
enterprise.. and i have slammed into case/power/sat slot issues already. Wh=
at sort of hardware must one use to grow to a 36 array system!

For the drives you could get a few big enclosures:

http://www.pc-pitstop.com/sata_enclosures/sat122urd.asp
http://www.pc-pitstop.com/sata_enclosures/scsas16rm.asp

I don't think these offer PMP (port multiplexer) support.  I would
look for ones that did if you're serious about doing something like
this.

If you used PMP with 4x drives per sata port, you would only need 9
sata ports in the PC to control the 36 drives.  Not sure what the
limits of PMP is, but 4x seems reasonable to me.

Greg
--=20
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
First 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.pdf

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com

--
To unsubscribe, send a message with 'unsubscribe linux-aio' in
the body to majordomo@kvack.org.  For more info on Linux AIO,
see: http://www.kvack.org/aio/
Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
