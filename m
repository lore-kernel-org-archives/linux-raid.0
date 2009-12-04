From: Neil Brown <neilb@suse.de>
Subject: Re: RAID5 demise or coma? after re-creating with a spare
Date: Sat, 5 Dec 2009 08:12:31 +1100
Message-ID: <20091205081231.22625302@notabene.brown>
References: <c775b4470912041146rcff477bj97e86eca5bdb2dfa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c775b4470912041146rcff477bj97e86eca5bdb2dfa@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lucian =?UTF-8?B?yJhhbmRvcg==?= <lucisandor@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 4 Dec 2009 14:46:39 -0500
Lucian =C8=98andor <lucisandor@gmail.com> wrote:

> Hi all,
> There is a problem with my Linux installation, and the drives get
> renamed and reordered all the time. Now, it just happened that the tw=
o
> degraded RAID5s won't return to life. The system would not boot, so I
> panicked and deleted: fstab, mdadm.conf, and some of the superblocks.
> Now Linux boots, but RAIDs are, of course, dead. I tried to re-create
> the arrays, but I cannot recall the correct order and my attempts
> failed. I believe that the partitions are OK, because I don't recall
> re-creating without "missing", but surely the superblocks are damaged
> and certanily most of them are zero now.
> Is there a short way to recover the degraded RAIDs without knowing th=
e
> order of drives? I have 6 drives in one (including "missing"), that
> gives 720 permutations. Also, clearing the superblocks is recoverable=
,
> isn't it?

Yes, 720 permutations.  But you can probably write a script
to generate them all ... how good are your programming skills?
Use "--assume-clean" to create the array so that it doesn't
auto-resync.  Then "fsck -n" to see of the data is even close
to correct.

And why would you think that erasing the superblocks is a recoverable
operation?  It isn't.

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
