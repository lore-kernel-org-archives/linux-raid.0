From: Neil Brown <neilb@suse.de>
Subject: Re: Why does one get mismatches?
Date: Thu, 25 Feb 2010 08:39:36 +1100
Message-ID: <20100225083936.07cd48ad@notabene.brown>
References: <869541.92104.qm@web51304.mail.re2.yahoo.com>
	<4B67451F.8040206@tmr.com>
	<20100202093738.44b4fece@notabene.brown>
	<4B684087.50001@tmr.com>
	<20100211161444.7a0ea7bb@notabene.brown>
	<20100211175133.GA30187@atlantis.cc.ndsu.nodak.edu>
	<4B7B0D45.7040801@tmr.com>
	<6db64f7872286165ac1fd3436e9d6476@localhost>
	<20100218100547.7aecdc34@notabene.brown>
	<4B853BBF.7000607@tmr.com>
	<yq1ocjemx46.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq1ocjemx46.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Steven Haigh <netwiz@crc.id.au>, Bryan Mesich <bryan.mesich@ndsu.edu>, Jon@eHardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 24 Feb 2010 11:12:09 -0500
"Martin K. Petersen" <martin.petersen@oracle.com> wrote:

> So realistically both disk blocks are wrong and there's a window until
> the new, correct block is written.  That window will only cause problems
> if there is a crash and we'll need to recover.  My main concern here is
> how big the discrepancy between the disks can get, and whether we'll end
> up corrupting the filesystem during recovery because we could
> potentially be matching metadata from one disk with journal entries from
> another.

After a crash, md will only read from one of the devices (the first) until a
resync has completed.  So there should be no room for more confusion than you
would expect on a single device.

NeilBrown
