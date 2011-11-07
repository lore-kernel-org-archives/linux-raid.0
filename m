From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [systemd-devel] systemd kills mdmon if it was started manually by user
Date: Mon, 7 Nov 2011 04:42:54 +0100
Message-ID: <CAPXgP115f-QezrxM4wZJ5EPJ=YGBAG7rcRtKNayD5mMO3UkjcQ@mail.gmail.com>
References: <20110208094843.GD11446@tango.0pointer.de> <AANLkTi=rFoqBwKdd0B3Xx6JrGdJdut0a2r=wFh0oSx73@mail.gmail.com>
 <20110208110730.GF23157@tango.0pointer.de> <AANLkTinmO9gsJcwr+0bGGuVJfF2dyM5rDJqqSkmh_hqs@mail.gmail.com>
 <20110208172822.GC21847@tango.0pointer.de> <CAA9_cmfhUyenz2B1=wDsUtKcrj-5uOURproUemje37bPpM4-Qw@mail.gmail.com>
 <20111031110613.GA1402@tango.0pointer.de> <20111102114416.7879b77f@notabene.brown>
 <20111102011615.GA5289@tango.0pointer.de> <20111102130334.09c3ab51@notabene.brown>
 <20111102133223.GC5119@tango.0pointer.de> <20111107135241.64ae261d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111107135241.64ae261d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Lennart Poettering <lennart@poettering.net>, linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Andrey Borzenkov <arvidjaar@mail.ru>, systemd-devel@lists.freedesktop.org
List-Id: linux-raid.ids

On Mon, Nov 7, 2011 at 03:52, NeilBrown <neilb@suse.de> wrote:

> However there is an important piece missing. =C2=A0When you remount,r=
o a
> filesystem, the block device doesn't get told so it thinks it is stil=
l open
> read/write. =C2=A0So md cannot tell mdmon that the array is now read-=
only

That ro/rw flag is visible in /proc/self/mountinfo, shouldn't it be
possible for mdmon to poll() that file and let the kernel wake stuff
up when the ro/rw flag changes, like we do for the usual mount changes
already?

Kay
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
