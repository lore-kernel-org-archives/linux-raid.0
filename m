From: jtroan@jt-sw.com
Subject: Re: Resurrecting a Dirty RAID-5
Date: Wed, 8 Jul 2015 22:57:19 -0400
Message-ID: <OF71F1F6CD.C562AA57-ON85257E7D.000FAD79-85257E7D.0010311B@jt-sw.com>
References: <OFC233BA12.DDED55A2-ON85257E7C.00420655-85257E7C.0043331F@jt-sw.com> <559D2374.7040208@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <559D2374.7040208@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Many, many thanks for the solution.  I was able to run to a pair of mdadm
-A commands to stitch both RAID devices back together and got it to
completely boot up on the two drives.

As expected, it did note the degraded md1 since the third drive was still
missing.  I'll install it when I have a few more spare moments, and have
left the system powered down for now.

I'm also thinking about adding a fourth drive and try to config it as a
hot-spare, giving me some extra margin for failure.

=======================================================================
John M. Troan  <jtroan@jt-sw.com>
Maintainer: Football Site @ JT-SW.com
  http://www.jt-sw.com/football
Chief of Computer Operations
U.S.S. Kitty Hawk / NCC-1659
=======================================================================


Phil Turmel <philip@turmel.org> wrote on 07/08/2015 09:19:48:

>
> To: jtroan@jt-sw.com, linux-raid@vger.kernel.org,
> Subject: Re: Resurrecting a Dirty RAID-5
>
> Good morning John,
>
> On 07/08/2015 08:14 AM, jtroan@jt-sw.com wrote:
>
> [trim /]
>
> > I booted from the RHEL 6.5 DVD and entered rescue mode.  Using
information
> > from the Linux RAID wiki [1], I was able to confirm that my sd0 and sd1
> > drives are alive and have all three partitions I had originally
deployed to
> > them -- /boot, /, and swap space.
> >
> > Following the advice on the wiki [1], I'm asking for some help in using
> > mdadm via rescue mode in trying to get this dirty RAID-5 back on its
feet
> > with the surviving two drives.  (I've got a third drive already on hand
> > that's I'll then use to bring the RAID back to full robustness.)
>
> From this report, you should only need to do a forced assembly from the
> rescue environment with the good devices.  Like so (substituting actual
> names):
>
> mdadm -Afv /dev/md2 /dev/sda2 /dev/sdb2
>
> If that fails, paste the verbose output in your reply here.
>
> If the above succeeds, you may shut down, plug in your new drive, and
> boot into your normal environment (still degraded, but should be
> bootable).  Then add the new drive's partitions to each array.
>
> Don't do *anything* else.
>
> HTH,
>
> Phil

