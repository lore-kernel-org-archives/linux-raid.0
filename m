From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Questions about 4k sector drives
Date: Mon, 03 May 2010 16:27:16 -0400
Message-ID: <yq17hnkpw7v.fsf@sermon.lab.mkp.net>
References: <4BD42B57.9000703@kusche.de> <1272206601.7734.4.camel@faldara>
	<4BDE0512.8070502@tmr.com>
	<x2v87f94c371005030630idaaad1e9ue3faff470bd318e1@mail.gmail.com>
	<4BDED1F2.102@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BDED1F2.102@cfl.rr.com> (Phillip Susi's message of "Mon, 3 May
	2010 09:38:58 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Greg Freemyer <greg.freemyer@gmail.com>, Bill Davidsen <davidsen@tmr.com>, Florian Kusche <flox@kusche.de>, linux-raid@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-raid.ids

>>>>> "Phillip" == Phillip Susi <psusi@cfl.rr.com> writes:

>> I don't know it any those drives exist yet, or if they ever will.
>> But the kernel topology info specifically supports providing the
>> above info and aiui parted uses it to choose the best partition
>> layout.

Phillip> AFAICS the kernel has a means of providing that information to
Phillip> user space, and parted will use it if it is provided, but the
Phillip> kernel has no means of obtaining that information from the
Phillip> drive, so it is always left as unknown, so parted defaults to 1
Phillip> MB alignment like Windows 7.

We have means of obtaining alignment and physical sector size
information from both SCSI and ATA drives.  But only if the drive
firmware provides the information, of course.

One currently shipping drive model on the market isn't reporting the
bigger physical block size.  But there are several other 4KB sector
products out there that are working just fine.

-- 
Martin K. Petersen	Oracle Linux Engineering
