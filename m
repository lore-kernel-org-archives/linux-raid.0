From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [mdadm GIT PULL] rebuild checkpoints, incremental assembly,
	volume delete/rename, and fixes
Date: Thu, 10 Jun 2010 23:42:16 -0700
Message-ID: <AANLkTimgVuEIkB2s9rra5QS11YMUSpvSkBOcbzza44LX@mail.gmail.com>
References: <1274921452.17973.253.camel@dwillia2-linux>
	<20100531113710.29e12d97@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100531113710.29e12d97@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, Doug Ledford <dledford@redhat.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, marcin.labun@intel.com, linux-raid <linux-raid@vger.kernel.org>, dave.jiang@intel.com
List-Id: linux-raid.ids

On Sun, May 30, 2010 at 6:37 PM, Neil Brown <neilb@suse.de> wrote:
> On Wed, 26 May 2010 17:50:52 -0700
> Dan Williams <dan.j.williams@intel.com> wrote:
>
>> Hi Neil,
>>
>> A collection of updates that have been separated onto individual top=
ic
>> branches. =A0I provide a url, summary, and full diff for each topic =
if you
>> want to do piecemeal pulls, otherwise the merged set is available he=
re:
>>
>> =A0 =A0 =A0 git://github.com/djbw/mdadm.git master
>>
>> Dan Williams (10):
>> =A0 =A0 =A0 mdmon: fix missing open of md/<dev>/recovery_start
>> =A0 =A0 =A0 mdmon: periodically checkpoint recovery
>
> I don't understand why you write 'idle' to 'sync_action' here.
> It should not be needed.
> Shouldn't we just be listening for events on sync_completed, and writ=
e
> them to the metadata??

This was an attempt to re-use the same mechanism for intermediate
checkpointing as array-shutdown checkpointing.

We currently checkpoint from md/resync_start and md/dev/recovery_start
at sync_action =3D=3D idle, but I will append a fix up patch to use
->last_checkpoint whenever is_resync_complete() is false.

By the way... listening for sync_completed events will fix a bug with
handling the write-pending event.  I have hit occasions, and others
have too [1], where the system locks up while resyncing.  I believe it
is because the wakeup of the blocked thread in md_write_start() races
with the sync thread doing a notification for a checkpoint.  I'll try
to verify that the lockup goes away when polling sync_completed, but
I'm fairly certain that is the bug.

>
>> =A0 =A0 =A0 imsm: dump each disk's view of the slot state
>> =A0 =A0 =A0 Kill subarray
>
> I assume that this is only allowed on an idle container because the
> volume index number of subsequent volumes will change, and as that is=
 used in
> the uuid the uuid will change, and that is bad.

Yes.

> 1/ Can you leave a 'place-holder' empty volume in the list, that a su=
bsequent
> =A0 create can use?

No, this would confuse the option-rom.

> 2/ As ddf doesn't suffer from this issue, the test for 'active volume=
 that
> =A0 will get a new uuid' should be in the super-intel code. =A0And it=
 should
> =A0 be exactly that test - if earlier volumes are active, that should=
 not be a
> =A0 problem.

Ok, this also needs communication with mdmon for the active case, I'll =
add that.

> =A0 Maybe a new method "safe_to_delete_volume".... or something.

I think we can just fail the delete in the handler.  It also appears
like we will be getting a unique identifier in a future update to the
metadata.  It will have a flag so that we can safely decide "use old
synthesized value" versus "use new stable/recorded value".

> Also: =A0-ENODOC.

Yeah, this was a rewrite of an earlier attempt so wanted to make sure
it was going in the right direction.  Will add.

>
>> =A0 =A0 =A0 Rename subarray
>
> Rename will change the uuid of the renamed array, but not the uuid of
> anything else, so it should be allowed if just the volume is inactive=
=2E

Like above need to close the loop with mdmon.

>
> Also it would be nicer if you factored out open_subarray in the previ=
ous
> patch, but that isn't a big issue (I would still accept if that was t=
he only
> issue).

Ok, I'll keep that in mind for next time.

>
>
>> =A0 =A0 =A0 Incremental: honor an 'enough' flag from external handle=
rs
>> =A0 =A0 =A0 Revert "Incremental: honor --no-degraded to delay assemb=
ly"
>> =A0 =A0 =A0 Merge branch 'subarray' into for-neil
>> =A0 =A0 =A0 imsm: robustify recovery-start detection
>
> "robistify" !! Is that a neologism ??

;-) right up there with "borkage".

> I've merged and pushed out the other bits which all seem OK.

Ok, there was one more you didn't comment on and didn't cherry-pick [2]

Dave Jiang (1):
      create: Check with OROM limit before setting default chunk size

Thanks,
Dan

[1]: https://bugzilla.redhat.com/show_bug.cgi?id=3D602457
[2]: http://git.kernel.org/?p=3Dlinux/kernel/git/djbw/mdadm.git;a=3Dcom=
mitdiff;h=3Df8cde132
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
