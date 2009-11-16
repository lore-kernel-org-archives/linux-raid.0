From: Neil Brown <neilb@suse.de>
Subject: Re: mismatch_cnt again
Date: Mon, 16 Nov 2009 12:37:47 +1100
Message-ID: <20091116123747.29592212@notabene.brown>
References: <87tyx6tpcb.fsf@frosties.localdomain>
	<4AF58B20.3000409@redhat.com>
	<87iqdlaujb.fsf@frosties.localdomain>
	<4AF74B61.6000102@rabbit.us>
	<20091109185632.GA2723@lazy.lzy>
	<73ebdcee169f46611d411755f9aaca5b.squirrel@neil.brown.name>
	<20091109215443.GA4143@lazy.lzy>
	<d99ca9481d2471073484c5d43d493b4d.squirrel@neil.brown.name>
	<20091110195222.GA2777@lazy.lzy>
	<19196.50782.113024.239657@notabene.brown>
	<20091115210542.GA6826@lazy.lzy>
	<DC9DEEF4919E420CB7CC2A160120D49A@m5>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <DC9DEEF4919E420CB7CC2A160120D49A@m5>
Sender: linux-raid-owner@vger.kernel.org
To: Guy Watkins <linux-raid@watkins-home.com>
Cc: 'Piergiorgio Sartor' <piergiorgio.sartor@nexgo.de>, 'Peter Rabbitson' <rabbit+list@rabbit.us>, 'Goswin von Brederlow' <goswin-v-b@web.de>, 'Doug Ledford' <dledford@redhat.com>, 'Michael Evans' <mjevans1983@gmail.com>, 'Eyal Lebedinsky' <eyal@eyal.emu.id.au>, 'linux-raid list' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, 15 Nov 2009 17:29:17 -0500
"Guy Watkins" <linux-raid@watkins-home.com> wrote:

> I have been following this issue some, and I think this could be a
> cause for silent corruption on RAID5 and RAID6.  I don't think this
> has been mentioned, if so, sorry.

RAID1/RAID10 are very different from RAID5/RAID6

RAID1/RAID10 can get 'mismatches' due to the particular behaviour
of swap or filesystems.  However this doesn't matter (the blocks that
are inconsistent are of no interest to the filesystem).

RAID5/RAID6 is careful not to allow any mismatches to creep in
due to any particular filesystem or swap activity.  This is because,
as you say, those mismatches could be significant to the RAID
algorithm even though they might be of no interest to the filesystem.

mismatches can only occur in a RAID5/RAID6 due to a software bug
in the md/raid code, or due to 'hardware errors' (including of course
drive firmware errors etc).

NeilBrown


> 
> If data blocks can be changed in memory before written to disk, even
> if the data blocks that were changed were never needed again from the
> disk, the other related blocks in the stripe are at risk.  If the
> parity blocks are computed, then the 1 data block in memory is
> changed, then the blocks are written to disk, the parity would be
> wrong.  If a disk fails and is re-added or replaced, the data block
> in that stripe will be computed using the changed block giving a now
> corrupt value.  I am assuming the stripe has some data blocks that
> have needed data and at least 1 that was not needed, and that block
> that was not needed was changed before writing it to disk.  And the
> disk that failed did not have the block that had been changed.
> 
> I have a hard time conveying my thought in text.  I hope you
> understand me.
> 
> Thanks for reading.

