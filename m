From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Guidance on reshape stuck at 0% after --grow
Date: Wed, 23 Sep 2015 19:11:42 +0100
Message-ID: <5602EB5E.6010703@youngman.org.uk>
References: <CAKWBTuFk4Tz20B4aZHgPF3FoEYXDqwQeKeAwN3Nt-cSAopUQ0Q@mail.gmail.com>
 <alpine.DEB.2.02.1509221224470.8750@uplift.swm.pp.se>
 <CAKWBTuG2AngM6joiODt15Qe+HAXfF6OnJVD-HNuNKikfyv-6MQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKWBTuG2AngM6joiODt15Qe+HAXfF6OnJVD-HNuNKikfyv-6MQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guillaume Paumier <guillaume.paumier@gmail.com>, Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23/09/15 04:20, Guillaume Paumier wrote:
> I figure I have a 50% chance of restoring the array, and 50% chance of
> making it completely unusable. I'm not very comfortable with those
> odds, so I would appreciate if anyone had any advice regarding what to
> do now, and alternatives to manually re-creating the array, if there
> are any.

Read up on loopback devices. Sorry, never done it, can't help
personally, but it sticks a ram-disk layer between mdadm and the actual
disk.

So the disks themselves are read-only, and you can try things out to see
what works. If it fails, you throw the loopback layer away, if it works
you can run it on the disk itself.

Cheers,
Wol
