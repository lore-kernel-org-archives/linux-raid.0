From: "Martin Bene" <martin.bene@icomedias.com>
Subject: Re: Checking consistency of Linux software RAID
Date: Wed, 9 Jul 2003 10:06:00 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4D618F6493CE064A844A5D496733D667031A3D@freedom.icomedias.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Class: urn:content-classes:message
To: Bernd Schubert <bernd-schubert@web.de>, Corey McGuire <coreyfro@coreyfro.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Bernd,

> /proc/mdstat is to monitor the status of your raid, so when 
> one drive fails it becomes dropped out of the raid-array. 
> Using mdadm you can monitor /proc/mdstat and it even can 
> send you a mail when one of your disks fails.

Yes, but it can only notify you of errors that it actually detects; as writen
before my concern is silent "bitrot", i.e unaccessed data on the disks going
bad.

> So if you really want to scan your disk once a week, why not 
> running 'dd if=/dev/mdX of=/dev/null'? 
> So every block of every raid-disk should become
> read and the md-driver should automatically drop a failing 
> disk  out of the raid.

Umm, no: this only reads each logical block but doesn't read the redundant
information on raid1 or raid5. Meaning: even if a read of the whole MD device
works, it doesn't guarantee that all sectors of all physical devices can
actually be read.

To check for errors, scanning the lowlevel devices (/dev/sd??) could work,
but still won't help for errors as described further down.

> I guess you could even try to repair a disk when it became 
> dropped out of the raid by running some scripts, but since 
> I never trusted any disk that had failed ones, I never worried 
> about it.

If a write is in progress during a power failure, chances are quite high that
you end up with at least one unreadable sector on the drive; repairing these
is quite OK and not a sign of the drive going bad. So having one sector bad
on drive 0 and another sector on drive 1 is not too farfetched - currently,
there's no good way to recover from such a situation: if you hit the bad
sector on drive 0, drive0 will be kicked from the array; when you hit the bad
sector on drive1 during resync, resync will fail.

With (some) hardware raid, solutions, a media scan will find both errors and
rewrite the bad sectors with recostructed data from the other drives. Quite a
useful feature but not yet possible with linux SW raid.

Bye, Martin
