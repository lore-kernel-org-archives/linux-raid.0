From: Phil Turmel <philip@turmel.org>
Subject: Re: linux raid wiki - backup files
Date: Sat, 19 Nov 2016 19:27:15 -0500
Message-ID: <ffb47575-b655-924d-8626-07b9e48a6371@turmel.org>
References: <583077D0.5070804@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <583077D0.5070804@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/19/2016 11:03 AM, Wols Lists wrote:
> I'm updating the mdadm overview at the moment, and I'm giving examples
> for changing raid levels etc.
> 
> Is a backup file still required? I get the impression with current
> kernels and mdadm, any required backup is put in the space left by "data
> offset", or if you're adding a disk it stores it in the space on that disk.

You can't change the data offset of zero for metadata v0.90 and v1.0,
the latter of which isn't obsolete.  So a backup file would be needed
for many --grow operations on those arrays.

> I'd also like to confirm my understanding of how a resize works ...

Just to clarify:  --grow with a change in number of devices or layout is
called a reshape, not a resize, even though the size may change.  Just
changing the amount of space used per device is a "resize".  A simple
resize never requires a backup file, as no chunks will move.

> If the number of raid devices is increased, am I right in thinking that
> a new stripe one is created from the old stripes one and two, then
> written, then the new stripe two is created from the old two and three,
> etc etc? In effect, the data slumps down from the old array into the new?
> 
> And of course the reverse when a device is removed - it starts with the
> highest stripe, which gets pulled upwards so the old array gets pulled
> up into the new?

Yes.  But the new stripes lay on top of the old stripes, unless you move
the data offset.  Which is why a backup file holds the old stripe just
in case.  If you can move the offset, you use the lower offset for the
lower addresses in the array, and the higher offset for the higher
addresses, on either side of the reshape position.

> (And during the reshape, you have a marker of the current stripe being
> updated, so any stripes above that get read from one array, and below
> they get read from the other.)

Yes.  And the stripe being worked on is "frozen" to prevent an upper
layer from interfering.

Phil
