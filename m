From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Triggering WARN_ON_ONCE in drivers/md/md.c::set_in_sync()
Date: Wed, 26 Jul 2017 11:40:16 +0100
Message-ID: <59787190.1000802@youngman.org.uk>
References: <1e68d380-762c-fbb4-73f9-842bd0fa7093@gentoo.org>
 <20170725221325.z6ozo6vmos3edwse@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170725221325.z6ozo6vmos3edwse@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Joshua Kinard <kumba@gentoo.org>, neilb@suse.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 25/07/17 23:13, Shaohua Li wrote:
> Interesting is if I disable CONFIG_SMP, there are several bugs exposed, I can't
> even boot my machine. Looks nobody tests UP case these days.

That's not good :-( Although I doubt there are many single-core machines
left these days, gentoo would almost certainly disable it even today if
appropriate. Although I can't imagine anyone running gentoo on a
single-core now :-) My old Thunderbird K8 based system used to struggle
before I retired it a few years back ...

Cheers,
Wol
