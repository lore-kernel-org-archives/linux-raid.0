From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: Chances of silent errors?
Date: Mon, 21 Jan 2013 22:39:22 +0000
Message-ID: <20733.50074.56591.634684@tree.ty.sabi.co.uk>
References: <28222077.12.1358798287217.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <28222077.12.1358798287217.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Coming from the zfs world, I've heard a few talk about the
> chances of "silent errors", meaning the checksum on the drives
> match, but the data being bad because of matching checksum
> (aka collisions). [ ... ]

That's a very narrow definition of "silent errors", they happen
in any case where incorrect data has been written to persistent
storage from memory, and yet no error has been signaled.

A common cause of those is software or firmware (HBA, disk, ...)
bugs, that either read or write the wrong blocks or modify them
in transit.

The classic report on this is from CERN's extensive testing:

  http://w3.hepix.org/storage/hep_pdf/2007/Spring/kelemen-2007-HEPiX-Silent_Corruptions.pdf

As to checksum collisions, that depends a bit on sector size and
the type/length of checksum and "enterprise" drives can usually
be formatted with different size sectors to accomodate different
size checksums. I would also suspect that it is far more likely
that very different blocks on the same disk have legitimately
the same checksum than a slightly corrupted block gets the same
checksum as the uncorrupted one...

For some context the details of the very informative SAVVIO
product manual here, page 15, the "Miscorrected Data" line:

  http://www.seagate.com/internal-hard-drives/enterprise-hard-drives/hdd/savvio-15k/

or also, page 43, the section "Protection Information".

But note that the URE is the *Unrecovered* Error Rate, that is
for errors that have been detected but not corrected, not the
*Undetected* Error Rate.

As someone famously said, as far as he knew his datacenter never
had an undetected error.
