From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Disk Monitoring
Date: Thu, 29 Jun 2017 12:14:00 +0200
Message-ID: <20170629101400.GA4604@metamorpher.de>
References: <20170628131917.BF1911235B6@gemini.denx.de>
 <CAJH6TXhJ8HoH=tnxreZ4EAFYQYDh05KHAQxwoLqp1f7zQM4N0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJH6TXhJ8HoH=tnxreZ4EAFYQYDh05KHAQxwoLqp1f7zQM4N0g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Cc: Wolfgang Denk <wd@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jun 29, 2017 at 11:52:01AM +0200, Gandalf Corvotempesta wrote:
> disk0 has sector X (unused) failed.
> It's unused, thus, kernel knows nothing about that and is operting
> normally, no warning message or anything. If you don't access sector
> X, you wont be notified.
> 
> Now, disk1 hard-fail. You have to replace that.
> During the resync, you have to resync the whole array, but disk0,
> sectorX is unreadable.
> The resync will fail and the whole array is down.

> Am I missing something?

Not really. It's just that you have to set up the monitoring yourself, 
whichever way you feel comfortable with.

SMART has a selftest feature which causes the disk to read sectors.
You can do whole disk at once (long selftest) or in segments 
(selective selftest). I prefer the selective since that allows you 
to place the selftest in the time window of least activity.

Instead of spending an entire day (or two) testing the whole drive 
you can put in an hour or two of testing every night and have it 
cover the entire drive over X days.

mdadm can also perform RAID checks, reading everything including 
parity, RAID layer would attempt to fix read errors then, and you 
can also check mismatch_cnt.

The mdadm checks can also done region by region to distribute 
load over several days but I think it's still not a direct option 
for mdadm, the region can be set via /proc or /sys somewhere...

Both smartmontools and mdadm should be set up to run such checks 
periodically, and instantly notify you by email if any problem occurs.

If a disk has problems, replace it, otherwise it's a gamble. 
Whatever promises RAID makes regarding redundancy, it always 
assumes the other drives to work 100%.

It's very unlikely to encounter read errors during rebuild if 
you ran regular checks and didn't forcibly keep bad drives.

Regards
Andreas Klauer
