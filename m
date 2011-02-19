From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Recovery Optimization?
Date: Sat, 19 Feb 2011 00:37:15 +0000
Message-ID: <AANLkTikwJAXMUg9ynF7xEmhSg5XNke0kajxQ8VtpSgbr@mail.gmail.com>
References: <ijn1hs$8nl$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ijn1hs$8nl$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Forrest <jlforrest@berkeley.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 19 February 2011 00:06, Jon Forrest <jlforrest@berkeley.edu> wrote:
> I'm just learning how the md system works so what
> I'm going to say might not be sensible.
>
> I read that if a disk in a RAID5 set goes bad, and the
> disk is replaced by a new one, that the recovery operation
> takes place blindly. By this I mean that all the stripes
> will be read so that new parity blocks can be written.
> But, there might be stripes that contain only blocks
> that aren't used by the filesystem. Wouldn't it be
> good when doing recovery if some kind of allocation
> map were created so that unused stripes wouldn't be
> restored. I would think that depending on how full
> the disk is that this could save time.
>
> Is this reasonable?
>
> Cordially,
> --
> Jon Forrest
> Research Computing Support
> College of Chemistry
> 173 Tan Hall
> University of California Berkeley
> Berkeley, CA
> 94720-1460
> 510-643-1032
> jlforrest@berkeley.edu
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

Isn't that what the bitmap is (partly) for?

// Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
