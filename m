From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Why does one get mismatches?
Date: Wed, 24 Feb 2010 11:12:09 -0500
Message-ID: <yq1ocjemx46.fsf@sermon.lab.mkp.net>
References: <869541.92104.qm@web51304.mail.re2.yahoo.com>
	<4B67451F.8040206@tmr.com> <20100202093738.44b4fece@notabene.brown>
	<4B684087.50001@tmr.com> <20100211161444.7a0ea7bb@notabene.brown>
	<20100211175133.GA30187@atlantis.cc.ndsu.nodak.edu>
	<4B7B0D45.7040801@tmr.com>
	<6db64f7872286165ac1fd3436e9d6476@localhost>
	<20100218100547.7aecdc34@notabene.brown> <4B853BBF.7000607@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B853BBF.7000607@tmr.com> (Bill Davidsen's message of "Wed, 24
	Feb 2010 09:46:23 -0500")
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Neil Brown <neilb@suse.de>, Steven Haigh <netwiz@crc.id.au>, Bryan Mesich <bryan.mesich@ndsu.edu>, Jon@eHardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Bill" == Bill Davidsen <davidsen@tmr.com> writes:

>> Absolute rubbish does seem to be a suitable phrase here.  There is no
>> question of data corruption.  When memory changes between being
>> written to one device and to another, this does not cause corruption,
>> only inconsistency.  Either the block will be written again
>> consistently soon, or it will never be read.

Bill> Just what is it that rewrites the data block? The user program
Bill> doesn't know it's needed, the filesystem, if any, doesn't know
Bill> it's needed, and as far as I can tell md doesn't do checksum
Bill> before issuing the write and after the last write is done. Doesn't
Bill> make a copy and write from that. So what sees that the data has
Bill> changed and rewrites it?

The filesystem updates the page, causing it to be marked dirty again.
The VM will then eventually schedule the page to be written out.  The
"when" depends on filesystem type and whether there's metadata or data
in the page.

In this discussion there seems to be a focus on the case where one
mirror is correct and one is not.  However, that's usually not how it
works out.  A more realistic scenario is that both mirror copies are
incorrect because the page was continuously updated.  I.e. both mirrors
have various degrees of new and stale data inside a 4KB block.

So realistically both disk blocks are wrong and there's a window until
the new, correct block is written.  That window will only cause problems
if there is a crash and we'll need to recover.  My main concern here is
how big the discrepancy between the disks can get, and whether we'll end
up corrupting the filesystem during recovery because we could
potentially be matching metadata from one disk with journal entries from
another.

-- 
Martin K. Petersen	Oracle Linux Engineering
