From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID halting
Date: Sun, 5 Apr 2009 13:54:19 -0500
Message-ID: <20090405185421.RJPR28081.cdptpa-omta04.mail.rr.com@Leslie>
References: <c268e4660904050705v73f1aa0eud93357f1e369110c@mail.gmail.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c268e4660904050705v73f1aa0eud93357f1e369110c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Drew' <drew.kay@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > The problem started immediately the last time I
> > rebuilt the array and formatted it as Reiserfs, after moving the drives
> out
> > of the old RAID chassis.
> 
> What file system were you using before ReiserFS?

Several, actually.  Since the RAID array kept crashing, I had to re-create
it numerous times.  I tried ext3 more than once, but the journal kept
getting corrupted, and fixing it lost several files.  Once I lost several
important files during a RAID expansion.  In some cases I converted to ext2,
and others I started out with ext2, but last I checked, one cannot grow an
ext2 file system on the fly.  I know at least once before it was reiserfs,
but I'm pretty sure it was under an earlier kernel, and probably an earlier
version of resierfs.

> I'm no expert but it seems, based on what you said about the raid
> resyncing just fine while a filesystem call blocked, you may want to
> look at the filesystem you're using. RAID provides a block level
> interface to the FS and if the block level interface is working and
> not reporting errors from lower levels, your culprit is higher up the
> chain, ie the FS.

I've suspected this may be the case from the outset.  I don't see a reiserfs
user's mailing list.  I posted on the development mailing list, but I
haven't received any response, assuming it isn't the wrong list in the first
place.  Of course, the fact the RAID level is working while the FS level is
not does not necessarily mean it's the FS' fault.  It could be an
interaction which is causing the problem, not a failure of either one
individually, or it could be the internal calls are working, but there is an
issue with external calls.

> It's perhaps a matter of personal preference but I try to avoid
> Reiser. It's not that it's a bad FS or anything but I've never had it
> work quite right for me. Plus, based on my read of how it works, it
> requires more processing on file creation due to the various
> optimization algorithms it uses.

Yes, but I had many problems with ext3, as well, and I definitely need a
file system which can be grown on the fly.

