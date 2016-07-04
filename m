From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: URE, link resets, user hostile defaults
Date: Tue, 5 Jul 2016 00:43:04 +0300
Message-ID: <20160704214304.GZ13212@reaktio.net>
References: <CAJCQCtT1qi1yLjE3Lor3ScVJx7aX4A_S_iM_=VhDtDCD_C9uqw@mail.gmail.com>
 <57721A47.8070203@suse.de>
 <CAJCQCtQ=DXWg6qK1+9bwQxrzpKUsRvaiaAnatYR-dupg7JOVzQ@mail.gmail.com>
 <20160629121751.GT15597@hungrycats.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160629121751.GT15597@hungrycats.org>
Sender: linux-raid-owner@vger.kernel.org
To: Zygo Blaxell <u0oo5pgu@umail.furryterror.org>
Cc: Chris Murphy <lists@colorremedies.com>, Hannes Reinecke <hare@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 29, 2016 at 08:17:51AM -0400, Zygo Blaxell wrote:
> On Tue, Jun 28, 2016 at 11:33:36AM -0600, Chris Murphy wrote:
> > On Tue, Jun 28, 2016 at 12:33 AM, Hannes Reinecke <hare@suse.de> wrote:
> > > Can you post a message log detailing this problem?
> >
> > Just over the weekend Phil Turmel posted an email with a bunch of back
> > reading on the subject of timeout mismatches for someone to read. I've
> > lost track of how many user emails he's replied to, discovering this
> > common misconfiguration, and get it straightened out and more often
> > than not helping the user recover data that otherwise would have been
> > lost *because* of hard link resetting instead of explicit read errors.
> 
> OK, but the two links you provided are not examples of these.
> 

Here's one of the threads where Phil explains the issue:

http://marc.info/?l=linux-raid&m=133665797115876&w=2

quote:


"A very common report I see on this mailing list is people who have lost arrays 
where the drives all appear to be healthy.  
Given the large size of today's hard drives, even healthy drives will occasionally 
have an unrecoverable read error.

When this happens in a raid array with a desktop drive without SCTERC,
the driver times out and reports an error to MD.  MD proceeds to
reconstruct the missing data and tries to write it back to the bad
sector.  However, that drive is still trying to read the bad sector and
ignores the controller.  The write is immediately rejected.  BOOM!  The
*write* error ejects that member from the array.  And you are now
degraded.

If you don't notice the degraded array right away, you probably won't
notice until a URE on another drive pops up.  Once that happens, you
can't complete a resync to revive the array.

Running a "check" or "repair" on an array without TLER will have the
opposite of the intended effect: any URE will kick a drive out instead
of fixing it.

In the same scenario with an enterprise drive, or a drive with SCTERC
turned on, the drive read times out before the controller driver, the
controller never resets the link to the drive, and the followup write
succeeds.  (The sector is either successfully corrected in place, or
it is relocated by the drive.)  No BOOM."



-- Pasi

