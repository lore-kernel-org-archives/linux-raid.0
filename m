From: Joshua Kinard <kumba@gentoo.org>
Subject: Re: Triggering WARN_ON_ONCE in drivers/md/md.c::set_in_sync()
Date: Wed, 26 Jul 2017 09:59:40 -0400
Message-ID: <8363f645-fb7d-cbad-c4e1-01a170feb6de@gentoo.org>
References: <1e68d380-762c-fbb4-73f9-842bd0fa7093@gentoo.org>
 <20170725221325.z6ozo6vmos3edwse@kernel.org>
 <59787190.1000802@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59787190.1000802@youngman.org.uk>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Shaohua Li <shli@kernel.org>, neilb@suse.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/26/2017 06:40, Wols Lists wrote:
> On 25/07/17 23:13, Shaohua Li wrote:
>> Interesting is if I disable CONFIG_SMP, there are several bugs exposed, I can't
>> even boot my machine. Looks nobody tests UP case these days.
> 
> That's not good :-( Although I doubt there are many single-core machines
> left these days, gentoo would almost certainly disable it even today if
> appropriate. Although I can't imagine anyone running gentoo on a
> single-core now :-) My old Thunderbird K8 based system used to struggle
> before I retired it a few years back ...
> 
> Cheers,
> Wol

The machine I'm running the raid1 array on is an SGI O2 (a.k.a., "IP32"),
purchased back in ~2005 and upgraded at random.  It's got a single RM7000 CPU @
350MHz, with 256KB L2, 1MB L3 and 1GB RAM.  About as maxed out as this machine
can get in Linux.  So, no, not fast, especially for compiling code, but such is
the way in Gentoo.  I'm actually re-installing it with a uClibc-based
filesystem, as glibc-linked binaries/libs shuffle too large of code around and
this thing's memory subsystem is rather slow.

For reference, anyone whose read the "UserFriendly" comic series, Erwin is an
SGI O2 machine.

-- 
Joshua Kinard
Gentoo/MIPS
kumba@gentoo.org
6144R/F5C6C943 2015-04-27
177C 1972 1FB8 F254 BAD0 3E72 5C63 F4E3 F5C6 C943

"The past tempts us, the present confuses us, the future frightens us.  And our
lives slip away, moment by moment, lost in that vast, terrible in-between."

--Emperor Turhan, Centauri Republic
