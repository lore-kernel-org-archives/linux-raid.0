From: greg@enjellic.com
Subject: Re: mismatch_cnt again
Date: Mon, 16 Nov 2009 15:36:55 -0600
Message-ID: <200911162136.nAGLatPb028438@wind.enjellic.com>
References: <neilb@suse.de>
Reply-To: greg@enjellic.com
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: Neil Brown <neilb@suse.de>
       "Re: mismatch_cnt again" (Nov 13,  1:28pm)
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, greg@enjellic.com
Cc: Eyal Lebedinsky <eyal@eyal.emu.id.au>, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Nov 13,  1:28pm, Neil Brown wrote:
} Subject: Re: mismatch_cnt again

Good afternoon to everyone, hope your week is starting well.

> On Thursday November 12, greg@enjellic.com wrote:
> > 
> > Neil/Martin what do you think?

> I think that if you found out which blocks were different and mapped
> that back through the filesystem, you would find that those blocks
> are not a part of any file, or possibly are part of a file that is
> currently being written.

I can buy the issue of the mismatches being part of a file being
written but that doesn't explain machines where the RAID1 array was
initialized and allowed to synchronize and which now show persistent
counts of mismatched sectors.

I can certainly buy the issue of the mismatches not being part of an
active file.  I still think this leaves the issue of why the
mismatches were generated unless we want to assume that whatever
causes the mismatch only affects areas of the filesystem which don't
have useful files.  Not a reassuring assumption.

> I guess I need to start logging the error address so people can
> start dealing with facts rather than fears.

I think that would be a good starting point.  If for no other reason
then to allow people to easily figure out the possible ramifications of a
mismatch count.

One other issue to consider.  We have RAID1 volumes with mismatch
counts over a wide variety of hardware platforms and Linux kernels.
In all cases the number of mismatched blocks are an exact multiple of
128.  That doesn't seem to suggest some type of random corruption.

This issue may all be innocuous but we have about the worst situation
we could have.  An issue which may be generating false positives for
potential corruption.  Amplified by the fact that major distributions
are generating what will be interpreted as warning e-mails about their
existence.  So even if the problem is innocuous the list is guaranteed
to be spammed with these reports let alone your inbox.... :-)

Just a thought in moving forward.

The 'check' option is primarily useful for its role in scrubbing RAID*
volumes with an eye toward making sure that silent corruption
scenarios don't arise which would thwart a resync.  Particularly since
you implemented the ability to attempt a sector re-write to trigger
block re-allocations.  This is a nice deterministic repair mechanism
which has fixed problems for us on a number of occassions.

I think what is needed is a 'scrub' directive which carries out this
function without incrementing mismatch counts and the like.  That
would leave a possibly enhanced 'check' command to report on
mismatches and carry out any remedial action, if any, that the group
can think of.

If a scrub directive were to be implemented it would be beneficial to
make it interruptible.  A 'halt' or similar directive would shutdown
the scrub and latch the last block number which had been examined.
That would allow a scrub to be resumed from that point in a subsequent
session.

With some of these large block devices it is difficult to get through
an entire 'check/scrub' in whatever late night window is left after
backups have run.  The above infra-structure would allow userspace to
gate the checking into whatever windows are available for these types
of activities.

> NeilBrown

Hope the above comments are helpful.

Best wishes for a productive week.

}-- End of excerpt from Neil Brown

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"When I am working on a problem I never think about beauty.  I only
 think about how to solve the problem.  But when I have finished, if
 the solution is not beautiful, I know it is wrong."
                                -- Buckminster Fuller
