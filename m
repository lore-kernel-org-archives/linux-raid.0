From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Re: [PATCH v2] md: also hot remove disk from pers when hot removing
Date: Mon, 19 Nov 2012 11:27:17 +0100
Message-ID: <50AA0985.6060601@profitbricks.com>
References: <1353081849-10516-1-git-send-email-sebastian.riemer@profitbricks.com> <CAA9_cmcViMsVMrxyEcC9yaHPq9Xc-5Dt63fMEJ+X+kZst8O9Fg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmcViMsVMrxyEcC9yaHPq9Xc-5Dt63fMEJ+X+kZst8O9Fg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <djbw@fb.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 17.11.2012 01:07, Dan Williams wrote:
> Hmm, how are you getting ->raid_disk set to -1 without the personality
> being notified?  That seems to be the source of the bug.  Otherwise it
> would seem the state_store("remove") path is also susceptible.
>
> --
> Dan
Thanks for your feedback!

Perhaps it's only something for my use-case of read-only
raid1-replicated volumes where I never have any spares. I don't set
->raid_disk to -1 when hot adding them. I have to put them directly to
their stored slot because I assemble read-only on read-only rdevs. So
the syncer never runs. Those read-only rdevs are coming from remote
storage. Imagine HA CD-ROM images.

My thought was that it would be cleaner behavior if the cleanup of an
rdev in the personality already happens when hot removing the disk.

You're right, the state_store("remove") path would need this change, too.

With the "slot_store" path I could trigger a panic when I hot added the
disk as spare, marked it insync and tried to give it the slot it belongs
to. I'll test this with the latest vanilla kernel and try to reproduce
this on rw volumes which I set to read-only. If I can also crash it that
way, I've got a proof that there is a bug.

If the disk isn't cleaned up in the pers, then hot_add_disk doesn't
return any error for raid1. Instead it crashes when referencing the old
pointer when calling "print_conf" in raid1.c.

Cheers,
Sebastian
