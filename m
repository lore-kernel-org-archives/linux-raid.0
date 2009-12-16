From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [GIT PATCH 0/2] external-metadata recovery checkpointing for
	2.6.33
Date: Tue, 15 Dec 2009 23:24:41 -0700
Message-ID: <e9c3a7c20912152224t22c8f891k80d3adbb322d9560@mail.gmail.com>
References: <20091213041123.12532.15225.stgit@dwillia2-linux.ch.intel.com>
	 <20091214150725.49de72f1@notabene.brown>
	 <1260837478.23193.33.camel@dwillia2-linux.ch.intel.com>
	 <e9c3a7c20912142019j280a243csf8c39a73fc3d0b06@mail.gmail.com>
	 <e9c3a7c20912151003y942a4aex803e1e6722f23f31@mail.gmail.com>
	 <20091216161613.226a6a38@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091216161613.226a6a38@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Dec 15, 2009 at 10:16 PM, Neil Brown <neilb@suse.de> wrote:
> I'm tempted to wait a bit longer and see if you find a solution,
> as you seem to be progressing quite well :-) =A0But I won't.
>
> I imagine there are two cases:
> =A01/ assembling an array from devices some of which might be partial=
ly
> =A0 =A0recovered,
> =A02/ re-adding a device to an array which is already active.
>
> In the first case, mdadm would:
> =A0 - add the disk (write to new_dev)
> =A0 - set the slot =A0- this sets 'In_sync'
> =A0 - set the recovery_start - this clears 'In_sync' as required.
>
> In the second case either mdadm or mdmon would:
> =A0 - write 'frozen' to sync_action, which would inhibit any call
> =A0 =A0 =A0 =A0 =A0 =A0 to remove_and_add_spares
> =A0 - add the disk
> =A0 - set recovery_start
> =A0 - set the slot
> =A0 - write 'recover' to sync_action
>
> It is unfortunate that the setting of 'slot' and 'recovery_start'
> must be in different orders in the different cases, but maybe that
> isn't a tragedy.
>
> Possibly I could change slot_store in the pers=3D=3DNULL case to not
> set In_sync if recovery_offset were not MaxSector, but
> I'm not sure it is worth the effort.
>
> Does that answer your concerns?

I had my mind set on a unified sysfs_add_disk() implementation that
would fallback to recovery_start=3D0 in older kernels.  But context
sensitive 'add' routines frees me from this mental rat hole.  Undoing
the In_sync bit after the slot write is palatable given the
alternatives.  Thanks for the nudge.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
