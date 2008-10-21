From: "David Lethe" <david@santools.com>
Subject: RE:  Re: Proactive Drive Replacement
Date: Tue, 21 Oct 2008 10:13:59 -0500
Message-ID: <A20315AE59B5C34585629E258D76A97C025BF23B@34093-C3-EVS3.exchange.rackspace.com>
References: <cccedfc60810201035m53873320tb069f333b707191b@mail.gmail.com> <gdj1c4$8nf$1@ger.gmane.org> <48FD94F9.3060400@dgreaves.com> <cccedfc60810210605w638ac471xbce0ceb616a0c141@mail.gmail.com> <A20315AE59B5C34585629E258D76A97C025BF0B0@34093-C3-EVS3.exchange.rackspace.com> <gdknuo$2qp$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <gdknuo$2qp$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Mario 'BitKoenig' Holbe
> Sent: Tuesday, October 21, 2008 9:12 AM
> To: linux-raid@vger.kernel.org
> Subject: Re: Proactive Drive Replacement
> 
> David Lethe <david@santools.com> wrote:
> > S.M.A.R.T. does not, has not, will not, ever ... identify bad
blocks.
> 
> Well, as you state yourself later, S.M.A.R.T. defines self-tests which
> are able to identify bad blocks. Though, they have to be triggered.
> 
> > Both families of disks provide for some self-test commands, but
these
> > commands do not scan the
> > entire surface of the disk
> 
> This is not true. The long self-test scans the entire surface of the
> disk at least for ATA devices, I don't know if it does that for SCSI
> devices too.
> ATA does also know about selective self-tests which are able to scan
> defineable surface areas - which is, at first, quite nice to identify
> more than one bad sector, and which is, at second, quite nice on
bigger
> devices as well... my ST31500341AS take about 4.5 hours for a long
> self-test.
> 
> > new bad block.  They report if you have a bad block if one is found
> in
> > the extremely small sample
> > of I/O it ran.
> 
> And, at least ATA devices report the LBA_of_first_error in the self-
> test
> log, so you can identify the first bad sector.
> 
> 
> regards
>    Mario
> --
> Singing is the lowest form of communication.
>                          -- Homer J. Simpson
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

The SCSI-family of self-test commands terminate after the first media
error.  This makes perfect sense
as if the disk fails, you ordinarily want to know that immediately,
rather than have the disk continue
scanning.   As such, self-test gives you the first bad block and that is
it.   

As for SATA/ATA self-tests, then all logs are limited to 512 bytes. If
you run the right self-test, then
You will get a PARTIAL list of bad blocks.  Specifically, you get 24
bytes which tell you the starting bad
Block.  You do not even get a range of bad blocks.  You just know that
block X is bad.   It doesn't
tell you if block X+1 is bad.  If block X+2 is bad, it will tell you
that, because it chews up another log
entry.  There is room for 20 entries. 

Not all disks support this type of self-test either. The ANSI spec says
this is optional, and it is a relatively 
recent introduction. 

So, at best, if you disk supports it, you can run self-tests that will
take half a day and give you a partial
list of bad blocks, between ranges of LBA numbers you want to scan. This
is correctly called the "SMART selective
self-test routine".   By the way, this is an OFF-LINE scan.  

So bottom line, Mario is correct in that there is a way to get a PARTIAL
list of bad blocks, if you have a disk
that supports this command, and you're willing to run an off-line scan
(not practical or a parity-protected RAID 
environment).

As original poster wanted to just use SMART to factor in known bad
blocks on a rebuild, then you can see that there
Is no viable option unless you already have a full list of known bad
blocks.  You have to find bad blocks as you 
just read from them as part of the rebuild for these types of disks).

It is possible that some vendor has implemented a SATA ON-LINE bad block
scanning mechanism that reports results and
doesn't kill I/O performance.  It would have to give full list of bad
blocks, or at least startingblock + range.

That would be wonderful as you could just read the list on regular
interval and rebuild stripes as necessary. You'd have
Self-healing parity. It still wouldn't protect against a drive failure,
but it would insure that you wouldn't have any
lost chunks due to a unreadable block on one of the surviving disks in a
RAID set.

David


