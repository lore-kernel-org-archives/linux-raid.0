From: Neil Brown <neilb@suse.de>
Subject: Re: [GIT PATCH 0/2] external-metadata recovery checkpointing for
 2.6.33
Date: Wed, 16 Dec 2009 16:16:13 +1100
Message-ID: <20091216161613.226a6a38@notabene.brown>
References: <20091213041123.12532.15225.stgit@dwillia2-linux.ch.intel.com>
	<20091214150725.49de72f1@notabene.brown>
	<1260837478.23193.33.camel@dwillia2-linux.ch.intel.com>
	<e9c3a7c20912142019j280a243csf8c39a73fc3d0b06@mail.gmail.com>
	<e9c3a7c20912151003y942a4aex803e1e6722f23f31@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20912151003y942a4aex803e1e6722f23f31@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 15 Dec 2009 11:03:06 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> On Mon, Dec 14, 2009 at 9:19 PM, Dan Williams <dan.j.williams@intel.c=
om> wrote:
> > On second thought, if we get to activate_spare() it's already too
> > late. =C2=A0Moving this to mdadm at assembly time (prior to setting
> > readonly) is a better approach.
> >
>=20
> Problem.  slot_store() in the array inactive case currently does:
>=20
>                 /* assume it is working */
>                 clear_bit(Faulty, &rdev->flags);
>                 clear_bit(WriteMostly, &rdev->flags);
>                 set_bit(In_sync, &rdev->flags);
>                 sysfs_notify_dirent(rdev->sysfs_state);
>=20
> i.e. sets the disk insync even if we specified a recovery_start <
> MaxSector.  If userspace can guarantee that the array stays inactive
> then it can write to 'recovery_start' after 'slot' and catch attempts
> to cold_add() out-of-sync disks on pre-2.6.33 kernels, but that gives
> a window of invalid configuration.  The other fix is to remove the
> set_bit(In_sync), and then for the pre-2.6.33 case userspace would
> need to disallow adding out-of-sync disks and force them through the
> hot_add() case.  This is how mdadm/mdmon currently operates, but that
> is a surprising ABI quirk when switching to/from 2.6.33.  A third
> option is to allow recovery_start_store to be modified while the arra=
y
> is read only. Although not my favorite, because it requires tricky
> mdmon logic to catch activate_spare() attempts before the monitor
> thread starts touching the array, it has the benefit of not changing
> any old behavior and no window of invalid configuration.  Thoughts??

I'm tempted to wait a bit longer and see if you find a solution,
as you seem to be progressing quite well :-)  But I won't.

I imagine there are two cases:
 1/ assembling an array from devices some of which might be partially
    recovered,
 2/ re-adding a device to an array which is already active.

In the first case, mdadm would:
   - add the disk (write to new_dev)
   - set the slot  - this sets 'In_sync'
   - set the recovery_start - this clears 'In_sync' as required.

In the second case either mdadm or mdmon would:
   - write 'frozen' to sync_action, which would inhibit any call
             to remove_and_add_spares
   - add the disk
   - set recovery_start
   - set the slot
   - write 'recover' to sync_action

It is unfortunate that the setting of 'slot' and 'recovery_start'
must be in different orders in the different cases, but maybe that
isn't a tragedy.

Possibly I could change slot_store in the pers=3D=3DNULL case to not
set In_sync if recovery_offset were not MaxSector, but
I'm not sure it is worth the effort.

Does that answer your concerns?

NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
