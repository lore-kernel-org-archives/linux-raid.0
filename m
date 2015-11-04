From: Edward Kuns <eddie.kuns@gmail.com>
Subject: Re: Advice requested re: hard drive setup for RAID arrays
Date: Wed, 4 Nov 2015 13:36:47 -0600
Message-ID: <CACsGCyQGChMLXfQ3G-DN+Y7mh9w7wFkmQ9274VFKBzSoOgaoUQ@mail.gmail.com>
References: <CAPpdf595q7qsU-3e4rm_9qKKdoOzZi6mVTtrr=Hczqk=UsNf5Q@mail.gmail.com>
	<563A0462.9000200@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <563A0462.9000200@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: o1bigtenor <o1bigtenor@gmail.com>, Brad Campbell <lists2009@fnarfbargle.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Nov 4, 2015 at 7:13 AM, Phil Turmel <philip@turmel.org> wrote:
> >>         if smartctl -l scterc,70,70 $i > /dev/null ; then
> >>                 echo -n $i " is good "
>
> "Good" clearly means the device has ERC support and the default timeout
> is OK.

To be technical, it means that smartctl was able to *set* the two
timeouts to 70 deciseconds aka 7.0 seconds.  Rather than query and
check the setting, that script just forces the setting and detects
whether or not it was set successfully.  I get this:

/dev/sda  is good Device Model:     Samsung SSD 840 PRO Series
/dev/sdb  is  bad Device Model:     SAMSUNG SSD 830 Series
/dev/sdc  is good Device Model:     HGST HDN724040ALE640
/dev/sdd  is good Device Model:     HGST HDN724040ALE640

From looking at smartctl information from before doing this, on all 3
of my "good" drives the feature was disabled initially.  Ouch.  That
explains so much.  Now I understand why one specific drive (no longer
in my system) would sometimes fall out of the array even though it
wasn't bad.  I now have this script in rc.local, still supported in my
Fedora version.  I checked.

> "Bad" means it doesn't support ERC, so the timeout is set to the
> work-around 180 seconds.  That's the best you can do for such drives.

Is there a reasonable way of finding out if a shorter setting is
appropriate for any specific drive?  Or would you say in general it's
not worth the effort of trying to find out?  Would you expect this
behavior to be any different for an SSD?

On computers being a tool.... I choose to look at it this way:  My car
is a tool.  It's on me to make sure I understand what maintenance is
required to keep it functioning properly if I care about uptime.
Linux distributions could maybe do a better job here for the
uninitiated, when you configure MD at install time, maybe have a
couple pointers on the install screens to let you know there are
certain things you really must do, as is discussed here regularly.
It's so easy to install modern Linux distributions that it's really
pretty easy to not realize that you're skipping *mandatory*
maintenance.

I experienced a drive failure some weeks ago and got very lucky.  I've
been watching this list since then and have learned of some mandatory
maintenance I wasn't doing.  I'm correcting that error, step by step.
:)

                  Eddie
