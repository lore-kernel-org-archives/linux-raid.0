From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Questions about 4k sector drives
Date: Tue, 4 May 2010 09:24:42 -0400
Message-ID: <4BE0201A.6080101@cfl.rr.com>
References: <4BD42B57.9000703@kusche.de> <1272206601.7734.4.camel@faldara>	<4BDE0512.8070502@tmr.com>	<x2v87f94c371005030630idaaad1e9ue3faff470bd318e1@mail.gmail.com>	<4BDED1F2.102@cfl.rr.com> <yq17hnkpw7v.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq17hnkpw7v.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Greg Freemyer <greg.freemyer@gmail.com>, Bill Davidsen <davidsen@tmr.com>, Florian Kusche <flox@kusche.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/3/2010 4:27 PM, Martin K. Petersen wrote:
> We have means of obtaining alignment and physical sector size
> information from both SCSI and ATA drives.  But only if the drive
> firmware provides the information, of course.

How?  I don't see any such information in the output of hdparm -I for
instance.

> One currently shipping drive model on the market isn't reporting the
> bigger physical block size.  But there are several other 4KB sector
> products out there that are working just fine.

The WD drive indeed reports a 512 byte sector size, but I also have an
SSD with a 512kb erase block size and it seems like these knobs were
intended to cover that as well, but again, the values exported by the
kernel in /sys are 0 and I don't see a way for the drive to report this
information to the kernel.
