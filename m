From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 0/3] UT and error case changes
Date: Tue, 15 Mar 2011 07:28:00 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D17A9910DD@irsmsx503.ger.corp.intel.com>
References: <20110314140052.20478.45664.stgit@gklab-128-013.igk.intel.com>
 <20110315085346.3bf9feb7@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110315085346.3bf9feb7@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of NeilBrown
> Sent: Monday, March 14, 2011 10:54 PM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> Neubauer, Wojciech
> Subject: Re: [PATCH 0/3] UT and error case changes
> 
> On Mon, 14 Mar 2011 15:09:20 +0100 Adam Kwolek <adam.kwolek@intel.com>
> wrote:
> 
> > The following series implements 2 changes:
> > 1. Fix for unit tests failure.
> > UT suits 12 and 13 fails, when backup file cannot be opened
> > for grow operation (backup file exists already).
> 
> Thanks - applied.
> 
> 
> >
> > 2. I've got proposal for handling/rollback metadata in error case.
> > Currently in case of error external metadata can remain in reshape
> state.
> > In some cases metadata can be automatically restored to initial state
> > (i.e. metadata during  imsm container operation can be rolled back
> > when error occurs on first reshaped array before reshape is started).
> > For such cases, additional superswitch function can be introduced.
> >
> > Metadata shouldn't be rolled back in restart case.
> > I'm passing restart flag to abort function in Grow.c only, as this is
> general rule.
> > In the same way array reshape state is checked.
> >
> > This is proposal, so I've put no implementation in to imsm handler (no
> metadata update is created yet).
> > Please let me know your opinion. If you will like it, I'll fill out
> gaps in imsm code.
> 
> I'm not sure.. it sounds like it might be a good idea, but I'd like to
> have
> some concrete examples to help me think about it.



I've got this idea during correcting UT so, i.e.:
wrong/already existing/ backup file name passed by used.
Backup file verification/opening is when metadata is in reshape state already.
This error causes mdadm exit at reshape position == 0. It is too early position for reshape restart.
User has manually restore metadata information and this can be quite difficult.

Metadata rollback can be possible for container operation if:
1. external metadata case (checked in Grow.c)
2. This is action on first array in container (check in metadata handler)
2. md doesn't start reshape  (checked in Grow.c)
3. Other conditions/metadata specific (checked in Grow.c)

We can also pass some additional status to reshape_container() to indicate that metadata is rolled back
and allow for container unfreeze in such case also.
This can allow mdadm to leave array/container in state that work is started from (hopefully ;)).

BR
Adam


> 
> Do you have an example in mind of an error which might be detected after
> the metadata has been updated, but before the reshape has actually
> started,
> and for which reverting the metadata update is likely to be useful?
> 
> The more general case of changing your mind just after a reshape has
> started and asking the reshape to revert would certainly be useful, but
> md isn't capable of that in general (yet).
> 
> Thanks,
> NeilBrown
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
