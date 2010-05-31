From: Neil Brown <neilb@suse.de>
Subject: Re: [mdadm GIT PULL] rebuild checkpoints, incremental assembly,
 volume delete/rename, and fixes
Date: Mon, 31 May 2010 11:37:10 +1000
Message-ID: <20100531113710.29e12d97@notabene.brown>
References: <1274921452.17973.253.camel@dwillia2-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1274921452.17973.253.camel@dwillia2-linux>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, Doug Ledford <dledford@redhat.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, marcin.labun@intel.com, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 26 May 2010 17:50:52 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> Hi Neil,
> 
> A collection of updates that have been separated onto individual topic
> branches.  I provide a url, summary, and full diff for each topic if you
> want to do piecemeal pulls, otherwise the merged set is available here:
> 
> 	git://github.com/djbw/mdadm.git master
> 
> Dan Williams (10):
>       mdmon: fix missing open of md/<dev>/recovery_start
>       mdmon: periodically checkpoint recovery

I don't understand why you write 'idle' to 'sync_action' here. 
It should not be needed.
Shouldn't we just be listening for events on sync_completed, and write
them to the metadata??

>       imsm: dump each disk's view of the slot state
>       Kill subarray

I assume that this is only allowed on an idle container because the 
volume index number of subsequent volumes will change, and as that is used in
the uuid the uuid will change, and that is bad.
1/ Can you leave a 'place-holder' empty volume in the list, that a subsequent
   create can use?
2/ As ddf doesn't suffer from this issue, the test for 'active volume that 
   will get a new uuid' should be in the super-intel code.  And it should
   be exactly that test - if earlier volumes are active, that should not be a
   problem.
   Maybe a new method "safe_to_delete_volume".... or something.

Also:  -ENODOC.

>       Rename subarray

Rename will change the uuid of the renamed array, but not the uuid of
anything else, so it should be allowed if just the volume is inactive.

Also it would be nicer if you factored out open_subarray in the previous
patch, but that isn't a big issue (I would still accept if that was the only
issue).


>       Incremental: honor an 'enough' flag from external handlers
>       Revert "Incremental: honor --no-degraded to delay assembly"
>       Merge branch 'subarray' into for-neil
>       imsm: robustify recovery-start detection

"robistify" !! Is that a neologism ??


I've merged and pushed out the other bits which all seem OK.

Thanks,
NeilBrown

