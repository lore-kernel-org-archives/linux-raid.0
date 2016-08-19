From: Chris Murphy <lists@colorremedies.com>
Subject: Re: URE, link resets, user hostile defaults
Date: Fri, 19 Aug 2016 09:30:31 -0600
Message-ID: <CAJCQCtR+uaW2WtXdKHFS=ucVNrFLhJVKjCGnJ=x3X1Fa6JRb9Q@mail.gmail.com>
References: <CAJCQCtT1qi1yLjE3Lor3ScVJx7aX4A_S_iM_=VhDtDCD_C9uqw@mail.gmail.com>
 <57721A47.8070203@suse.de> <CAJCQCtQ=DXWg6qK1+9bwQxrzpKUsRvaiaAnatYR-dupg7JOVzQ@mail.gmail.com>
 <20160629121751.GT15597@hungrycats.org> <20160704214304.GZ13212@reaktio.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160704214304.GZ13212@reaktio.net>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?UGFzaSBLw6Rya2vDpGluZW4=?= <pasik@iki.fi>
Cc: Zygo Blaxell <u0oo5pgu@umail.furryterror.org>, Chris Murphy <lists@colorremedies.com>, Hannes Reinecke <hare@suse.de>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Jul 4, 2016 at 3:43 PM, Pasi K=C3=A4rkk=C3=A4inen <pasik@iki.fi> wr=
ote:
> On Wed, Jun 29, 2016 at 08:17:51AM -0400, Zygo Blaxell wrote:
>> On Tue, Jun 28, 2016 at 11:33:36AM -0600, Chris Murphy wrote:
>> > On Tue, Jun 28, 2016 at 12:33 AM, Hannes Reinecke <hare@suse.de> wrote=
:
>> > > Can you post a message log detailing this problem?
>> >
>> > Just over the weekend Phil Turmel posted an email with a bunch of back
>> > reading on the subject of timeout mismatches for someone to read. I've
>> > lost track of how many user emails he's replied to, discovering this
>> > common misconfiguration, and get it straightened out and more often
>> > than not helping the user recover data that otherwise would have been
>> > lost *because* of hard link resetting instead of explicit read errors.
>>
>> OK, but the two links you provided are not examples of these.
>>
>
> Here's one of the threads where Phil explains the issue:
>
> http://marc.info/?l=3Dlinux-raid&m=3D133665797115876&w=3D2
>
> quote:
>
>
> "A very common report I see on this mailing list is people who have lost =
arrays
> where the drives all appear to be healthy.
> Given the large size of today's hard drives, even healthy drives will occ=
asionally
> have an unrecoverable read error.
>
> When this happens in a raid array with a desktop drive without SCTERC,
> the driver times out and reports an error to MD.  MD proceeds to
> reconstruct the missing data and tries to write it back to the bad
> sector.  However, that drive is still trying to read the bad sector and
> ignores the controller.  The write is immediately rejected.  BOOM!  The
> *write* error ejects that member from the array.  And you are now
> degraded.
>
> If you don't notice the degraded array right away, you probably won't
> notice until a URE on another drive pops up.  Once that happens, you
> can't complete a resync to revive the array.
>
> Running a "check" or "repair" on an array without TLER will have the
> opposite of the intended effect: any URE will kick a drive out instead
> of fixing it.
>
> In the same scenario with an enterprise drive, or a drive with SCTERC
> turned on, the drive read times out before the controller driver, the
> controller never resets the link to the drive, and the followup write
> succeeds.  (The sector is either successfully corrected in place, or
> it is relocated by the drive.)  No BOOM."


The more I think about this, the more the command timer for SATA and
USB drives default just needs to change. It is really the simplest
solution to the problem. Parsing for device SCT ERC support, and then
whether or not there are drive firmware bugs enabling it is risky. And
it's an open question if it persists on all drives after suspend (to
RAM or disk).

Further the problem is if SCT ERC is enabled by default, and the user
wants to disable it for some reason, they might not be able to do this
simply from user space with smartctl -l scterc because I've
encountered drives that only accept one state change, changing it back
to disabled causes the device to "crash" and vanish off the SATA bus.
Clearly a firmware bug.



--=20
Chris Murphy
