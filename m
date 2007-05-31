From: Mike Accetta <maccetta@laurelnetworks.com>
Subject: Re: When does a disk get flagged as bad?
Date: Wed, 30 May 2007 22:28:18 -0400
Message-ID: <5822.1180578498@mdt.dhcp.pit.laurelnetworks.com>
References: <1180066595.21028.112.camel@w100>
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: Your message of "Thu, 24 May 2007 23:16:35 CDT."
             <1180066595.21028.112.camel@w100>
Sender: linux-raid-owner@vger.kernel.org
To: Alberto Alonso <alberto@ggsys.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Alberto Alonso writes:
> OK, lets see if I can understand how a disk gets flagged
> as bad and removed from an array. I was under the impression
> that any read or write operation failure flags the drive as
> bad and it gets removed automatically from the array.
> 
> However, as I indicated in a prior post I am having problems
> where the array is never degraded. Does an error of type:
> end_request: I/O error, dev sdb, sector ....
> not count as a read/write error?

I was also under the impression that any read or write error would
fail the drive out of the array but some recent experiments with error
injecting seem to indicate otherwise at least for raid1.  My working
hypothesis is that only write errors fail the drive.  Read errors appear
to just redirect the sector to a different mirror.

I actually ran across what looks like a bug in the raid1
recovery/check/repair read error logic that I posted about
last week but which hasn't generated any response yet (cf.
http://article.gmane.org/gmane.linux.raid/15354).  This bug results in
sending a zero length write request down to the underlying device driver.
A consequence of issuing a zero length write is that it fails at the
device level, which raid1 sees as a write failure, which then fails the
array.  The fix I proposed actually has the effect of *not* failing the
array in this case since the spurious failing write is never generated.
I'm not sure what is actually supposed to happen in this case.  Hopefully,
someone more knowledgeable will comment soon.
--
Mike Accetta

ECI Telecom Ltd.
Data Networking Division (previously Laurel Networks)
