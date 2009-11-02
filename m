From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: md[adm] device names
Date: Mon, 02 Nov 2009 14:21:26 +0300
Message-ID: <4AEEC0B6.8020301@msgid.tls.msk.ru>
References: <4AEC33A2.6050408@msgid.tls.msk.ru> <19182.16585.929763.745870@notabene.brown> <20091102082424.GD7626@lapse.rw.madduck.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091102082424.GD7626@lapse.rw.madduck.net>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, Michael Tokarev <mjt@tls.msk.ru>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

martin f krafft wrote:
> also sprach Neil Brown <neilb@suse.de> [2009.11.02.0315 +0100]:
>> Numbers are meaningless.  I would much rather have "/dev/md/home" or
>> "/dev/md/backup" or whatever.  But as I said, old names should still
>> work.
>=20
> =85 except sysfs exposes device names =E0 la md1, right? I agree with
> Michael that we should either have numbers or names, but not both.
> http://bugs.debian.org/553896 came in today, which is just another
> instance of confusion resulting from multiple choices.

If I see it right, Neil's plan was to keep /dev/mdN naming intact,
_and_ introduce _additional_ /dev/md/friendlyname scheme a-la
/dev/disk/by-*/foo.  _That_ looks quite good thing.  It wasn't
an intention to have multiple device nodes.

But what bothers me in this whole thing is why, out of the sudden,
in initramfs we've /dev/md/0 (in a subdir) instead of /dev/md0
(the traditional way and the kernel device naming).

> I personally don't have a problem with numbers; they are as
> meaningless or -full as partition numbers, and I used stuff like
> /dev/sda5 on my systems for decades without problems. The trend
> these days is dm/LVM, and that gives us decent names like
> /dev/mapper/home, and I see the benefit in moving towards
> /dev/md/home, but it needs to be done consistently, and either one
> or the other.

No need to _move_ towards /dev/md/home, as long as you're happy
with /dev/md1.  Having /dev/md1 device _and_ /dev/md/home symlink
is handy (And lvm from this point of view is something entirely
different since it _never_ had any meaningful numbers).  What
is questionable is why or how the "main" device node got moved
from /dev/md1 to /dev/md/1.  Which is what this new bugreport
is about.

/mjt
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
