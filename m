From: George Rapp <george.rapp@gmail.com>
Subject: Re: Reshape stalled at first badblock location (was: RAID 5
 --assemble doesn't recognize all overlays as component devices)
Date: Wed, 22 Feb 2017 13:39:39 -0500
Message-ID: <CAF-KpgbXtdjDYgX6phKGj6fFVE6UvNRjYv99rVPiSs5z+EyO=A@mail.gmail.com>
References: <CAF-KpgY0ySvCN9ftbDmW_P6wDiyfN2yWE6=NECVru4=vCe+pbQ@mail.gmail.com>
 <20170221175801.wt64t2tzcvg3sfmc@kernel.org> <CAF-KpgZ3tZQy93PwUFk0RZRfv1w0_WBRhU+FQ9C4=Hhh44H7KQ@mail.gmail.com>
 <a9fc6148-decb-3494-75af-b9280412975e@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a9fc6148-decb-3494-75af-b9280412975e@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Shaohua Li <shli@kernel.org>
Cc: Linux-RAID <linux-raid@vger.kernel.org>, Matthew Krumwiede <matt.krumwiede@me.com>, NeilBrown <neilb@suse.com>, Jes Sorensen <Jes.Sorensen@gmail.com>, tomasz.majchrzak@intel.com
List-Id: linux-raid.ids

On Wed, Feb 22, 2017 at 11:17 AM Phil Turmel <philip@turmel.org> wrote:
>
> On 02/21/2017 08:12 PM, George Rapp wrote:
>
> > Before I proceed for real, does clearing the badblocks log and
> > assembling the array seem like my best option?
>
> Yes.  And consider disabling badblocks on all of your arrays.
>
> The badblocks feature does nothing but guarantee that errors
> encountered on a device become uncorrectable, even if the cause
> of the error was a transient communications or power problem, not
> a true media flaw.  Bad block tracking at the OS level is
> appropriate for ancient MFM and RLL devices that lack modern
> firmware, or similar low-level devices.  And since the MD raid
> bad block tracking feature does *not* provide redirects to
> usable spare sectors, the feature is useless for such devices,
> too.
>
> MD raid currently does *nothing* when a badblock entry reduces
> the redundancy available for a particular sector in an array.
> The badblocks feature is incomplete, has no upside for modern
> component devices, and should not be used.

OK, thanks. I removed the badblocks list as previously proposed and
reassembled the RAID 5 array, and the reshape completed on 9 drives.
I'm re-adding the tenth drive for redundancy before fsck'ing and
mounting the filesystem to see what we've done.  8^)

Current RAID status uploaded to
https://app.box.com/v/raid-status-2017-02-22-txt for them as are
interested.

Thanks to all for your input and help!

George
