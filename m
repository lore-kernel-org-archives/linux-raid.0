From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Re: Strange intermittant errors + RAID doesn't fail the disk.
Date: Fri, 7 Jul 2006 00:29:41 +0200
Message-ID: <bb145bd20607061529i6d84ca2at35e3a11144e4608c@mail.gmail.com>
References: <bb145bd20606300932x2268822k78561e549996aef3@mail.gmail.com>
	 <17573.52096.655463.808666@cse.unsw.edu.au>
	 <bb145bd20606302313x557f94d8xd69cce83731e2a4b@mail.gmail.com>
	 <bb145bd20607060601x33519be7tb4c4812ab54cc7c@mail.gmail.com>
	 <17581.35131.123710.652968@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17581.35131.123710.652968@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> md is very dependant on the driver doing the right thing.  It doesn't
> do any timeouts or anything like that - it assumes the driver will.
> md simply trusts the return status from the drive, and fails a drive
> if and only if a write to the drive is reported as failing (if a read
> fails, md trys to over-write with good data first).
>
> I don't know exactly how the driver was responding to the bad cable,
> but it clearly wasn't returning an error, so md didn't fail it.

There were a lot of errors in dmesg -- seems like they did not get
passed up to md? I find it surprising that the md layer doesn't have
its own timeouts, but then I know nothing about such things :)

Thanks for clearing this up for me,

C.

[...]
ata2: port reset, p_is 8000000 is 2 pis 0 cmd 44017 tf d0 ss 123 se 0
ata2: status=0x50 { DriveReady SeekComplete }
sdc: Current: sense key: No Sense
   Additional sense: No additional sense information
ata2: handling error/timeout
ata2: port reset, p_is 0 is 0 pis 0 cmd 44017 tf 150 ss 123 se 0
ata2: status=0x50 { DriveReady SeekComplete }
ata2: error=0x01 { AddrMarkNotFound }
sdc: Current: sense key: No Sense
   Additional sense: No additional sense information
[repeat]
