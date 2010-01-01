From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Subject: Re: Size limitation?
Date: Fri, 1 Jan 2010 21:28:51 +0000
Message-ID: <73e903671001011328t24405d6oaf418d2b75cd42ca@mail.gmail.com>
References: <201001011457.24334.mmclagan@invlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201001011457.24334.mmclagan@invlogic.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: mmclagan+reply@invlogic.com
List-Id: linux-raid.ids

On Fri, Jan 1, 2010 at 7:57 PM, Michael McLagan <mmclagan@invlogic.com>=
 wrote:
> Hello,
>
> =A0 I'm trying to set up a large array but isn't working. =A0I tried
> Googling size limits, etc and came up empty.
>
> The problem is that with 10 drives (300GB SCSI), the array is coming =
up
> with 500GB of space?!? =A0I did an experiment and when the array size
> exceeds 2TB, it fails/wraps?
>

Looked at the mdadm output and ... Wow that's strange. You aren't
supposed to be hitting any size limits there as far as I know, and I
can't see that you're doing anything wrong - The "wraparound" just
shouldn't be happening in my opinion. (But I'm a RAID rookie so don't
take that as an expert judgement. Perhaps rather as some solidarity in
a strange situation.) Anyway ...

> Is there a solution (simple or otherwise) for this? =A0The machine ru=
ns
> 2.6.29.5 (anything later causes the machine to lock up :( ). =A0I'm n=
ot
> sure if mdadm or the kernel is the problem either.
>

That's kinda scary. Is this some unusual architecture or hardware
configuration? I don't want to take this off-topic if you have
determined the kernel version to be a fixed variable, but: Do you know
why a newer kernel won't go? To me, newer-kernels-crashing indicates
an irregularity under the hood.

> Any suggestions appreciated

Try upgrading mdadm. Either latest 2.x or 3.1.x. What the hey, try
both. It's quite easy to compile mdadm yourself, and its for-stability
releases are usually that: More stable. I've built mdadm a number of
times when fooling around and it has always been quite good to me.
(I.e. no exploding-in-face.)

Good luck!

-- Kristleifur
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
