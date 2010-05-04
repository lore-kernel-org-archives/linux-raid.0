From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Questions about 4k sector drives
Date: Tue, 04 May 2010 11:29:47 -0400
Message-ID: <yq1mxwfznv8.fsf@sermon.lab.mkp.net>
References: <4BD42B57.9000703@kusche.de> <1272206601.7734.4.camel@faldara>
	<4BDE0512.8070502@tmr.com>
	<x2v87f94c371005030630idaaad1e9ue3faff470bd318e1@mail.gmail.com>
	<4BDED1F2.102@cfl.rr.com> <yq17hnkpw7v.fsf@sermon.lab.mkp.net>
	<4BE0201A.6080101@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BE0201A.6080101@cfl.rr.com> (Phillip Susi's message of "Tue, 4
	May 2010 09:24:42 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Freemyer <greg.freemyer@gmail.com>, Bill Davidsen <davidsen@tmr.com>, Florian Kusche <flox@kusche.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Phillip" == Phillip Susi <psusi@cfl.rr.com> writes:

>> We have means of obtaining alignment and physical sector size
>> information from both SCSI and ATA drives.  But only if the drive
>> firmware provides the information, of course.

Phillip> How?  

http://oss.oracle.com/~mkp/docs/linux-advanced-storage.pdf


Phillip> I don't see any such information in the output of hdparm -I for
Phillip> instance.

You need hdparm-9.27 or later.


>> One currently shipping drive model on the market isn't reporting the
>> bigger physical block size.  But there are several other 4KB sector
>> products out there that are working just fine.

Phillip> The WD drive indeed reports a 512 byte sector size, but I also
Phillip> have an SSD with a 512kb erase block size and it seems like
Phillip> these knobs were intended to cover that as well, but again, the
Phillip> values exported by the kernel in /sys are 0 and I don't see a
Phillip> way for the drive to report this information to the kernel.

There are no means to report things like the erase block size.  A few
years ago there was a push in the industry to define a set of parameters
that would make sense for flash drives.  For a variety of reasons,
however, this effort never really took off.  There are some things in
the pipeline but it's mostly statistics and life expectancy stuff.

On well-designed drives the erase block size and other physical
characteristics do not matter because the firmware uses an approach akin
to a log-structured filesystem.

For low-end devices (where we could potentially benefit from knowing the
physical characteristics) the problem is that this information is often
considered part of the vendor's secret sauce.  Another common concern is
that exporting a set of metrics squarely puts the drive in the "poorly
designed" bucket and that's a marketing disaster.

It is a lengthy process to get stuff pushed through the standards
organizations.  Even if the industry had been successful in defining a
set of SSD characteristics it would have taken quite a while for things
to get ratified and show up in devices.  The expectation was that early
SSD designs exhibiting side effects from being flash-based would be
obsolete by then.

And as it turns out you can get an SSD with a sane firmware for $100 and
change these days...

-- 
Martin K. Petersen	Oracle Linux Engineering
