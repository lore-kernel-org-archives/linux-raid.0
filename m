From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Subject: Re: Disk Monitoring
Date: Thu, 29 Jun 2017 11:52:01 +0200
Message-ID: <CAJH6TXhJ8HoH=tnxreZ4EAFYQYDh05KHAQxwoLqp1f7zQM4N0g@mail.gmail.com>
References: <20170628131917.BF1911235B6@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170628131917.BF1911235B6@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2017-06-28 15:19 GMT+02:00 Wolfgang Denk <wd@denx.de>:
> As Wol already pointed out, you should use  smaartctl  to monitor
> the state of the disk drives, ideally on a regular base.  Changes
> (increases) of numbers like "Reallocated Sectors", ""Current Pending
> Sectors" or ""Offline Uncorrectable Sectors" are always suspicious.
> If they increase just by one, and then stay constant for weeks you
> can probably ignore it.  But if you see I/O errors in the system
> logs and/or "Reallocated Sectors" increasing every few days then you
> should not wait much longer and replace the respective drive.

Sure, but smart is not always reliable.
My personal experience was that Patrol Read feature on LSI controllers [1]
saved me multiple times. During a patrol read some bad sectors where found
(probably in an unallocated part of the array, thus the OS doesn't
know anything about that).

I've proactive replaced the drive and the day after resync, another
disk failed totally.
Without "Patrol Read" that scrubs all disks, one by one (consistency
check is a different thing),
probably this server would fails totally with data loss

Linux kernels detect something bad only by accessing to the failed
sector. If that sector is not used,
kernel knows nothing. HW RAID like LSI are able to read the whole
disks, block by block, even the unused part,
detecting failures before something is trying to write to that sector.

If you have a bad sector on an unused part of the array, when you have
to rebuild due to another disk failure, you'll
hit a URE and the whole array is failed.

Simple example:

disk0 has sector X (unused) failed.
It's unused, thus, kernel knows nothing about that and is operting
normally, no warning message or anything. If you don't access sector
X, you wont be notified.

Now, disk1 hard-fail. You have to replace that.
During the resync, you have to resync the whole array, but disk0,
sectorX is unreadable.
The resync will fail and the whole array is down.

Am I missing something?

[1] http://www.dell.com/downloads/global/power/ps1q06-20050212-Habas.pdf
