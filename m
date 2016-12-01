From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH v2 3/9] imsm: give md list of known bad blocks on startup
Date: Thu, 01 Dec 2016 17:33:01 -0500
Message-ID: <wrfjshq7z3du.fsf@redhat.com>
References: <1480424555-31509-1-git-send-email-tomasz.majchrzak@intel.com>
        <1480424555-31509-4-git-send-email-tomasz.majchrzak@intel.com>
        <wrfjzikh7whw.fsf@redhat.com>
        <20161130085134.GA29667@proton.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161130085134.GA29667@proton.igk.intel.com> (Tomasz Majchrzak's
        message of "Wed, 30 Nov 2016 09:51:34 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tomasz Majchrzak <tomasz.majchrzak@intel.com> writes:
> On Tue, Nov 29, 2016 at 05:27:07PM -0500, Jes Sorensen wrote:
>> Tomasz Majchrzak <tomasz.majchrzak@intel.com> writes:
>> > On create set bad block support flag for each drive. On assmble also
>> > provide a list of known bad blocks. Bad blocks are stored in metadata
>> > per disk so they have to be checked against volume boundaries
>> > beforehand.
>> >
>> > Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
>> > ---
>> >  super-intel.c | 59
>> > +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>> >  1 file changed, 59 insertions(+)
>> 
>> Tomasz,
>> 
>> Thanks for posting 1/9 v3 - I was in the process of applying this set,
>> but something is causing a conflict.
>> 
>> > diff --git a/super-intel.c b/super-intel.c
>> > index 421bfbc..b2afdff 100644
>> > --- a/super-intel.c
>> > +++ b/super-intel.c
>> [snip]
>> > @@ -7160,6 +7212,12 @@ static struct mdinfo *container_content_imsm(struct supertype *st, char *subarra
>> >  			info_d->events = __le32_to_cpu(mpb->generation_num);
>> >  			info_d->data_offset = pba_of_lba0(map);
>> >  			info_d->component_size = blocks_per_member(map);
>> > +
>> > +			info_d->bb.supported = 0;
>> > +			get_volume_badblocks(super->bbm_log, ord_to_idx(ord),
>> > +					     info_d->data_offset,
>> > +					     info_d->component_size,
>> > +					     &info_d->bb);
>> >  		}
>> >  		/* now that the disk list is up-to-date fixup recovery_start */
>> >  		update_recovery_start(super, dev, this);
>> 
>> This hunk is failing as my tree doesn't have the line above:
>> 			info_d->component_size = blocks_per_member(map);
>> 
>> I can merge this manually, but I prefer to be sure we are in sync just
>> in case. Where did that line come from - did I miss an earlier patch?
>
> My bad. I have just sent new version of the patch. Previously I had tested
> it against my local mirror of your repository which happened to run
> out-of-sync few days ago. Please keep telling me when patches do not apply
> cleanly, it would help me to spot my working environment issues.

Hi Tomek,

All good, thanks for the quick update. I'm looking through the patches
now, I did find a minor nit in patch 7 as well - I'll respond to that
one.

Cheers,
Jes
