From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: mismatch_cnt again
Date: Tue, 10 Nov 2009 09:03:10 -0500
Message-ID: <yq1tyx2o4td.fsf@sermon.lab.mkp.net>
References: <4AF4C247.6050303@eyal.emu.id.au> <4AF4D323.6020108@panix.com>
	<4AF5268D.60900@eyal.emu.id.au>
	<4877c76c0911070008m789507f8h799d419287740ca5@mail.gmail.com>
	<87tyx6tpcb.fsf@frosties.localdomain> <4AF58B20.3000409@redhat.com>
	<87iqdlaujb.fsf@frosties.localdomain> <4AF74B61.6000102@rabbit.us>
	<20091109185632.GA2723@lazy.lzy>
	<73ebdcee169f46611d411755f9aaca5b.squirrel@neil.brown.name>
	<20091109215443.GA4143@lazy.lzy>
	<d99ca9481d2471073484c5d43d493b4d.squirrel@neil.brown.name>
	<4AF92DBD.5010102@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF92DBD.5010102@rabbit.us> (Peter Rabbitson's message of "Tue,
	10 Nov 2009 10:09:17 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: NeilBrown <neilb@suse.de>, Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Goswin von Brederlow <goswin-v-b@web.de>, Doug Ledford <dledford@redhat.com>, Michael Evans <mjevans1983@gmail.com>, Eyal Lebedinsky <eyal@eyal.emu.id.au>, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Peter" == Peter Rabbitson <rabbit+list@rabbit.us> writes:

Peter> Bingo - and according to the list archive many of us are getting
Peter> mismatches without swap anywhere near the raid in question. The
Peter> current situation is more akin to "Ok folks get in the plane,
Peter> we're deploying in 2 hours, and btw your chute is not going to
Peter> open and there is nothing you can do about it" How is that for a
Peter> threat model :)

Way back we used to lock pages down entirely for I/O submission.  At
some point the writeback bit was introduced to gate the page during the
actual (physical) write operation only.  That made locking trickier and
not all filesystems correctly adapted to this.  ext[234] in particular
have issues of varying degrees, somewhat amplified by their use of
buffer_heads to track buffers instead of pages.  See the recent thread
about corruption with ext4 in 2.6.32+ for examples of this.

It's not just RAID consistency that breaks.  In the ext4 case above we
end up with garbled blocks being written to a single drive.

Add data integrity protection to the mix (btrfs, DIX) and all hell
breaks loose if you change the buffer after the checksum has been
generated.  So while modifying pages in flight has kinda-sorta worked
for a while (i.e. the window of error is small) it's something we'll
simply have to stop doing to support new features in the storage stack.
You'll be glad to know there's discussion about merging the debug patch
(which marks pages read-only during writeback) into ext4.

FWIW, XFS and btrfs both use the page writeback bit correctly and never
change a page while it is undergoing I/O.

-- 
Martin K. Petersen	Oracle Linux Engineering
