From: Shaohua Li <shli@fb.com>
Subject: Re: [PATCH 0/6] raid5-cache fixes
Date: Wed, 7 Oct 2015 20:24:59 -0700
Message-ID: <20151008032459.GA3087573@devbig084.prn1.facebook.com>
References: <cover.1443973492.git.shli@fb.com>
 <87mvvu6rfr.fsf@notabene.neil.brown.name>
 <20151008025603.GA3007253@devbig084.prn1.facebook.com>
 <87egh66oas.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87egh66oas.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

On Thu, Oct 08, 2015 at 02:18:19PM +1100, Neil Brown wrote:
> Shaohua Li <shli@fb.com> writes:
> >
> > please hold 5 currently. I'm a little confused about the In_sync bit.
> > It's quite tricky to handle this bit. For example, if both In_sync and
> > Journal bits are set, I'll need move checking the 'Journal' bit ahead of
> > checking the 'In_sync' in super_1_sync (current patch haven't done it
> > yet, it's a bug). There are similar cases in mdadm too. This makes me
> > thinking about What's the exact role for the In_sync bit for journal
> > disk. The comments in the bit definition doesn't give an answer. We can
> > use the Faulty bit for error handling. Any thoughts?
> 
> "In_sync" effectively means that recovery_offset == MaxSector.  It means
> all data which should be on the device is on the device (except as
> described in the bad-block log).
> It is set at array-creation time or when recovery completes, and is
> cleared when an error is detected.  It is useful for differentiating
> between a spare being added (without In_sync) or a recently failed
> device being re-added (with In_sync).
> 
> None of this really relates to the Journal.  So as you say, it doesn't
> mean much to set that flag for the log.
> 
> Maybe r5l_log_disk_error() should check Error rather than In_sync.  Was
> there a reason you didn't do that in the first place?

Thanks. No, likely a misuse.
