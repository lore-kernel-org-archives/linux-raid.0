From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: writing zeros to bad sector results in persistent read error
Date: Sun, 29 Jun 2014 19:50:16 -0400
Message-ID: <yq18uof9sxz.fsf@sermon.lab.mkp.net>
References: <B7EA34DA-1064-45B1-B0C0-B7C423C7EB47@colorremedies.com>
	<20140607075140.277c0880@natsu>
	<0E76B97E-96DF-43A3-B8EC-4867964BF8E9@colorremedies.com>
	<20140609193723.79F1B3809B0@gemini.denx.de>
	<19559C36-08B4-4C2F-ABC3-9DE79BE37B54@colorremedies.com>
	<53970ACE.6080001@turmel.org>
	<6C47950B-13E8-479C-BC3B-C21C379A95FB@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6C47950B-13E8-479C-BC3B-C21C379A95FB@colorremedies.com> (Chris
	Murphy's message of "Sat, 28 Jun 2014 18:05:29 -0600")
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Phil Turmel <philip@turmel.org>, Wolfgang Denk <wd@denx.de>, Roman Mamedov <rm@romanrm.net>, "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Chris" == Chris Murphy <lists@colorremedies.com> writes:

Chris,

Chris> The SCSI layer is clearly combining the bs=512 count=8 into a
Chris> single write command. This is inhibited with oflag=direct.

It's not really the SCSI layer that does any of this but the VM and/or
the I/O scheduler (depending on how things were submitted).

Chris> I also found intermittent issuance of READ_10 to the drive,
Chris> before WRITE_10, but wasn't able to figure out why it's
Chris> intermittant. 

It's either the page cache doing readahead or you doing partial writes
to uncached pages.

You can flush the page cache like this:

	echo 3 > /proc/sys/vm/drop_caches

>> You do know that drives are physically incapable of writing partial
>> sectors?  It has to be emulated, either in drive firmware or OS
>> driver stack.  What you've written suggests you've missed that basic
>> reality.  The rest is operator error.  Roman and Wolfgang were too
>> polite when pointing out the need for bs=4096 -- it isn't 'should',
>> it is 'must'.

Chris> That's true for oflag=direct, it's not true without it.

Correct.

In general, a buffered write() call in dd or any other userland app does
not have a 1:1 mapping with a SCSI WRITE command at the bottom of the
stack. The pages in question will simply be marked dirty and eventually
flushed to disk.

You can force a more block-centric behavior by using synchronous/direct
I/O.

Chris> Also included for interest is the result of issue an hdparm write
Chris> command. It works without a size specification, so I don't
Chris> actually know what happens on the drive itself, plus the command
Chris> that gets issued to the drive isn't "WRITE_10" but "ATA_16".

That's because the ATA command gets encapsulated in a SCSI command so it
can pass through the SCSI layer.

-- 
Martin K. Petersen	Oracle Linux Engineering
