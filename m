From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [systemd-devel] systemd kills mdmon if it was started manually by user
Date: Wed, 2 Nov 2011 15:33:29 +0100
Message-ID: <CAPXgP12RsaFeGK+dQ2hwFjQawhN+QDn1+K8t6jkJ-XSRyautJw@mail.gmail.com>
References: <20110208094843.GD11446@tango.0pointer.de> <AANLkTi=rFoqBwKdd0B3Xx6JrGdJdut0a2r=wFh0oSx73@mail.gmail.com>
 <20110208110730.GF23157@tango.0pointer.de> <AANLkTinmO9gsJcwr+0bGGuVJfF2dyM5rDJqqSkmh_hqs@mail.gmail.com>
 <20110208172822.GC21847@tango.0pointer.de> <CAA9_cmfhUyenz2B1=wDsUtKcrj-5uOURproUemje37bPpM4-Qw@mail.gmail.com>
 <20111031110613.GA1402@tango.0pointer.de> <20111102114416.7879b77f@notabene.brown>
 <20111102011615.GA5289@tango.0pointer.de> <20111102130334.09c3ab51@notabene.brown>
 <20111102133223.GC5119@tango.0pointer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111102133223.GC5119@tango.0pointer.de>
Sender: linux-raid-owner@vger.kernel.org
To: Lennart Poettering <lennart@poettering.net>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Andrey Borzenkov <arvidjaar@mail.ru>, systemd-devel@lists.freedesktop.org
List-Id: linux-raid.ids

On Wed, Nov 2, 2011 at 14:32, Lennart Poettering <lennart@poettering.ne=
t> wrote:
> On Wed, 02.11.11 13:03, NeilBrown (neilb@suse.de) wrote:
>
>> > I'd really prefer if we could somehow make it something that isn't
>> > special and we could just shutdown
>>
>> It must remain running until the array that it manages is read-only =
and will
>> never be written to again. =C2=A0Then it can be shutdown gracefully.
>> It may be awkward to shut it down gracefully at the moment - I'm not=
 sure. =C2=A0I
>> can certainly fix that.
>
> The big thing is that if things are done that way you'll always have =
the
> chicken and egg problem: you really need to shut down mdmon before
> unmounting root, but currently you require us to do it in the other
> order too.

Yeah, that's just madness.

I talked to Harald, and the currently preferred idea is the version
where we start mdmon in the initramfs and never touch it again, and it
runs until the initramfs unmounts the rootfs and shuts down the box.

In that picture, the mdmon process is conceptually more like a kernel
thread than a userspace process. It can not be updated, can not be
restarted. The only way to update it is to rebuild initramfs and
reboot the box.

>> Each instance of mdmon manages a set of arrays and must remain runni=
ng
>> until all of those arrays are readonly (or shut down). =C2=A0This al=
lows it to
>> record that all writes have completed and mark the array as 'clean' =
so a
>> resync isn't needed at next boot.
>
> Why doesn't the kernel do that on its own?

Because somebody was naive enough to think that userspace can tear
down the base it lives on, which in reality is just a total mess in
the real world. :)

>> True. =C2=A0A version upgrade would need to stash the binary in /run=
=2E
>> It might be better to go the 'remount-readonly - then stop mdmon'
>> route.
>
> It is not sufficient to stash the binary in /run, you'd also need to
> include your own libc and in fact every single other library or file =
you
> use.

I don't think any of these update games in a running system make much
sense in the end.

>> I guess it still needs to be able to differentiate processes that ar=
e holding
>> write-access to the filesystem and so need to be killed, from proces=
ses are
>> only holding read-access and so can be permitted to remain.

> But again, I believe the right solution is to fix mdmon to make it
> something that can be shut down normally at any time. That might mean
> that some of its code has to move to the kernel, but otherwise you'll
> always have this chicken and egg problem, and you cannot fix it prope=
rly.

That would be the ideal solution. Having the roofs depending on a
tools that runs off the rootfs just asks for serious trouble. If all
that can't move to the kernel, the initramfs-only solution with the
above mentioned constrains, seems like the best option.

People who like to put their rootfs on a userspace managed raid device
just get what they asked for. :)

Kay
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
