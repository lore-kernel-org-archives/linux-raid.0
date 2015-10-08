From: Shaohua Li <shli@fb.com>
Subject: Re: [PATCH 4/6] md: don't export log device
Date: Wed, 7 Oct 2015 21:31:30 -0700
Message-ID: <20151008043121.GA3189627@devbig084.prn1.facebook.com>
References: <cover.1443973492.git.shli@fb.com>
 <7aecea0895b46e28c2b8a876a83da10d7f30d7f1.1443973492.git.shli@fb.com>
 <87pp0q6s1i.fsf@notabene.neil.brown.name>
 <20151008031644.GA3063621@devbig084.prn1.facebook.com>
 <87bnca6lli.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87bnca6lli.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

On Thu, Oct 08, 2015 at 03:16:41PM +1100, Neil Brown wrote:
> Shaohua Li <shli@fb.com> writes:
> >> 
> >> Neither of these chunks should be needed.
> >> ->raid_disk of an active devices is only set to -1 if ->hot_remove_disk
> >> succeeds.
> >> You have make ->hot_remove_disk fail for Journal devices, so ->raid_disk
> >> will be >= 0.
> >
> > I agree the raid5_remove_disk part is superficial, I fixed in an updated
> > patch. I still didn't get the point what can prevent a journal disk is
> > removed. Currently the raid_disk is always -1 for journal disk. If it
> > should be >=0, what value it should be? We give journal disk a special
> > role '0xfffd' currently.
> 
> Oh, are we leaving the ->raid_disk at -1 for the journal?  I hadn't
> noticed that.  I don't feel comfortable it.  Too much code assumes that
> <0 means "not in use".
> 
> Probably set it to 0, and add a check to setup_conf(), and adjust the
> check in run().  md_update_sb() probably need to be careful of journals
> too (to not change ->recovery_offset).
> I wonder what 'slot_show' should report for the journal.... maybe
> "journal"??

->raid_disk >= 0 is for normal raid disks. If we use it, we will have
two disks with ->raid_disk 0, it sounds weird. Currently we add the
'test(Journal, rdev->flags)' check in different places to destinguish
journal disk. We will need to audit the code which assumes ' < 0 means
not in use'. We will probably need to audit the same code if we set
->raid_disk 0 for journal. Neither is perfect.

Thanks,
Shaohua
