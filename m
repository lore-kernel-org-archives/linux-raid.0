From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Spares and partitioning huge disks
Date: Sat, 15 Jan 2005 03:13:12 +0300
Message-ID: <41E86018.1070903@tls.msk.ru>
References: <crmt7e$8d6$1@sea.gmane.org> <200501092226.25910.maarten@ultratux.net> <20050109222900.GA12793@janus> <200501100016.58847.maarten@ultratux.net> <20050110081526.GA15920@janus> <41E80188.60601@conterra.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41E80188.60601@conterra.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dieter Stueken wrote:
[]
> I think read errors are to be handled very differently compared to disk
> failures. In particular the affected disk should not be kicked out
> incautious. If done so, you waste the real power of the RAID5 system
> immediately! As long, as any other part of the disk can still be read,
> this data must be preserved by all means. As long as only parts of a disk
> (even of different disks) can't be read, it is not a fatal problem, as long
> as the data can still be read from an other disk of the array. There is no
> reason to kill any disk in advance.

I once was successeful at recovering a (quite large at the time being)
filesystem after multiple read errors developed by two disks running in
a raid1 array (as it turned out it was the chassis fan who was at fault,
the disks become too hot and the weather was hot too, and two disks went
bed almost at once).  Raid kicked one disk out of the array after first
read error, and, thanks God (or whatever), second disk developed error
right after that, so the data was still in sync.  I've read everything
from one disk (dd conv=noerror), noticing the bad blocks, and when read
the missing blocks from the second drive (dd skip=n seek=n).  I'm afraid
to think what'd be done if the second drive lasted a bit longer (the
filesystem was quite active).  (And yes I know it was me who really was
at fault, because I didn't enable various sensors monitoring...)

More, I was once successeful at recovering raid5 array after two disk
failure, but it was much more difficult...  And I wasn't able to recover
all data at that time, just because I had no time to figure out how to
reconstruct data using parity block (I only recovered the data blocks,
zeroing unreadable ones).

That all to say: yes indeed, this lack of "smart error handling" is
a noticieable omission in linux software raid.  There are quite some
(sometimes fatal to the data) failure scenarios that'd not had happened
provided the smart error handling where in place.

/mjt
