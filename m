From: "David Lethe" <david@santools.com>
Subject: RE:
Date: Sun, 5 Apr 2009 00:33:24 -0500
Message-ID: <F2C688D6A021E34CB81C0E631EF4C093017FF4C3@34093-C4-EVS1.exchange.rackspace.com>
References: <49D7FF44.8010309@gmail.com> <20090405052113.LAKK19140.cdptpa-omta03.mail.rr.com@Leslie>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <20090405052113.LAKK19140.cdptpa-omta03.mail.rr.com@Leslie>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Lelsie Rhorer
> Sent: Sunday, April 05, 2009 12:21 AM
> To: linux-raid@vger.kernel.org
> Subject: RE:
> 
> > You should note that the drive won't know a sector it just wrote is
> > bad until it reads it
> 
> Yes, but it also won't halt the write for 40 seconds because it was
> bad.
> More to  the point, there is no difference at the drive level between
a
> bad
> sector written for a 30Gb file and a 30 byte file.
> 
> > ....are you sure you actually successfully wrote all of that data
and
> that
> >it is still there?  Pretty sure, yeah.  There are no errors in the
> filesystem, and every file I have written works.  Again, however, the
> point
> is there is never a problem once the file is created, no matter how
> long it
> takes to write it out to disk.  The moment the file is created,
> however,
> there may be up to a 2 minute delay in writing its data to the drive.
> 
> > And it is not the writes that kill when you have a drive going bad,
> it
> > is the reads of the bad sectors.    And to create a file, a number
of
> > things will likely need to be read to finish the file creation, and
> if
> > one of those is a bad sector things get ugly.
> 
> Well, I agree to some extent, except that why would it be loosely
> related to
> the volume of drive activity, and why is it 5 drives stop reading
> altogether
> and 5 do not?  Furthermore, every single video file gets read, re-
> written,
> edited, re-written again, and finally read again at least once,
> sometimes
> several times, before being finally archived.  Why does the kernel log
> never
> report any errors of any sort?
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

All of what you report is still consistent with delays caused by having
to remap bad blocks
The O/S will not report recovered errors, as this gets done internally
by the disk drive, and the O/S never learns about it. (Queue depth
settings can account for some of the other "weirdness" you reported.

Really, if this was my system I would run non-destructive read tests on
all blocks; along with the embedded self-test on the disk.  It is often
a lot easier and more productive to eliminate what ISN'T the problem
rather than chase all of the potential reasons for the problem.  


