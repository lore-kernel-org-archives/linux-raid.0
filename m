From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [OT] best tape backup system?
Date: Wed, 23 Feb 2005 00:52:32 +0300
Message-ID: <421BA9A0.5010402@tls.msk.ru>
References: <200502221651.j1MGp1922341@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <200502221651.j1MGp1922341@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy wrote:
> I have NOT been able to share a SCSI cable/card with disks and a tape drive.
> Tried for days.  I would get disk errors, or timeouts.  I corrected the
> problem by putting the tape drive on a dedicated SCSI bus/card.  I don't
> recall the details of the failures, since it has been well over a year now.
> But I do know I only had problems while using the tape drive and the disks
> at the same time.  Like, during a backup.  The disks were happy while the
> tape drive was idle.  I also swapped parts, it had no effect.  I assumed
> Linux does not like to share SCSI.

There may be various reasons for this, and i think all of them are related
to hardware only, esp. to the SCSI bus.  Eg, some modern disk drives don't
understand SE mode anymore, so can't be plugged into an scsi bus with at
least one SE device.  On the other hand, it was qutie common for esp. old
tapes to NOT understand LVD mode.  Obviously you can't mix that sort of
devices on the same bus.  I guess the bus where you drives are is in LVD
mode while tapes works in SE mode...

BTW, I've seen quite modern tape drive with an old scsi connector (I don't
even remember anymore how it's called -- the one which looks pretty like
an IDE connector but a bit wider and with more (80?) pins; with max speed
of 20Mb/sec aka 10MHz or so) inside the case and with an adaptor for current
68pin scsi connector standard.  Obviously it works in SE mode only (that bus
worked in that mode only).  Don't remember which vendor that drive was...

/mjt
