From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: [OT] best tape backup system?
Date: Tue, 22 Feb 2005 20:26:00 -0500
Message-ID: <200502230126.j1N1Q5923933@www.watkins-home.com>
References: <421BA9A0.5010402@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <421BA9A0.5010402@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: 'Michael Tokarev' <mjt@tls.msk.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I know a thing or 2 about SCSI.  I know I had it correct.  1 config was all
wide LVD (2940U2W).  My card has a LVD and a SE port on the same logical
SCSI bus.  Another config was wide LVD disks and a narrow SE tape.  Another,
my disks support SE, I had all SE wide and narrow.  Correct terminators in
each case.  I also tried a 2940UW, no LVD, all SE.  All configs worked if I
only used the disks or the tape drives, but failed if I used disks and tape
at the same time.

I am convinced I had many valid configurations, none worked until I used 2
SCSI cards.  My system has grown, it now has 5 SCSI buses, 17 disk drives
and 2 tape drives.  Works just fine.  But no tape on the same SCSI bus as
disks.

Guy


-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Michael Tokarev
Sent: Tuesday, February 22, 2005 4:53 PM
To: linux-raid@vger.kernel.org
Subject: Re: [OT] best tape backup system?

Guy wrote:
> I have NOT been able to share a SCSI cable/card with disks and a tape
drive.
> Tried for days.  I would get disk errors, or timeouts.  I corrected the
> problem by putting the tape drive on a dedicated SCSI bus/card.  I don't
> recall the details of the failures, since it has been well over a year
now.
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
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

