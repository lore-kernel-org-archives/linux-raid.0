From: Jure =?UTF-8?Q?Pe=C3=A8ar?= <pegasus@nerv.eu.org>
Subject: raid10 ... (was: Re: ANNOUNCE: mdadm 1.7.0)
Date: Sat, 14 Aug 2004 04:18:14 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040814041814.56d1e6c9.pegasus@nerv.eu.org>
References: <16665.33913.505058.370245@cse.unsw.edu.au>
	<20040811155507.307d91d0.pegasus@nerv.eu.org>
	<16666.42485.178856.530123@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16666.42485.178856.530123@cse.unsw.edu.au>
To: linux-raid@vger.kernel.org
Cc: dm-devel@redhat.com
List-Id: linux-raid.ids

On Thu, 12 Aug 2004 09:04:21 +1000
Neil Brown <neilb@cse.unsw.edu.au> wrote:

> Data is laid out in a raid0 style, but multiple copies of each chunk
> are possible.  There can be "near" copies, where copies of the one
> block are at the same or similar offsets in different drives, and
> "far" copies, where copies of the one block are at a substantial
> offset from one drive to the next.

=2E.. this really fuels my imagination.

Imagine having a pool of drives, where chunks of data are distributed e=
venly
across all drives in a redundant manner. If one drive dies, the chunks =
that
are not redundant anymore get their copies on the remaining drives, pro=
vided
that there's enough space left; if one or more drives are added to the
array, new chunks are written there until the balance is reached again.

Disk space could be the first key for balancing across the drives, with
transfer rate or seek time maybe added later. Maybe the pool could even
adapt dinamically to the i/o patterns ...=20

Am i dreaming (it's well over 4am here :) ? Or is something like this
possible? Maybe not with a md personality, but by some daemon that woul=
d be
taking care of a dm map?


--=20

Jure Pe=C4=8Dar
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
