From: Phil Turmel <philip@turmel.org>
Subject: Re: Reshape stalled at first badblock location (was: RAID 5
 --assemble doesn't recognize all overlays as component devices)
Date: Wed, 22 Feb 2017 11:17:37 -0500
Message-ID: <a9fc6148-decb-3494-75af-b9280412975e@turmel.org>
References: <CAF-KpgY0ySvCN9ftbDmW_P6wDiyfN2yWE6=NECVru4=vCe+pbQ@mail.gmail.com>
 <20170221175801.wt64t2tzcvg3sfmc@kernel.org>
 <CAF-KpgZ3tZQy93PwUFk0RZRfv1w0_WBRhU+FQ9C4=Hhh44H7KQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAF-KpgZ3tZQy93PwUFk0RZRfv1w0_WBRhU+FQ9C4=Hhh44H7KQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Rapp <george.rapp@gmail.com>, Shaohua Li <shli@kernel.org>
Cc: Linux-RAID <linux-raid@vger.kernel.org>, Matthew Krumwiede <matt.krumwiede@me.com>, NeilBrown <neilb@suse.com>, Jes.Sorensen@gmail.com
List-Id: linux-raid.ids

On 02/21/2017 08:12 PM, George Rapp wrote:

> Before I proceed for real, does clearing the badblocks log and 
> assembling the array seem like my best option?

Yes.  And consider disabling badblocks on all of your arrays.

The badblocks feature does nothing but guarantee that errors
encountered on a device become uncorrectable, even if the cause
of the error was a transient communications or power problem, not
a true media flaw.  Bad block tracking at the OS level is
appropriate for ancient MFM and RLL devices that lack modern
firmware, or similar low-level devices.  And since the MD raid
bad block tracking feature does *not* provide redirects to
usable spare sectors, the feature is useless for such devices,
too.

MD raid currently does *nothing* when a badblock entry reduces
the redundancy available for a particular sector in an array.
The badblocks feature is incomplete, has no upside for modern
component devices, and should not be used.

Phil
