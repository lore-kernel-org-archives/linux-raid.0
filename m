From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [systemd-devel] systemd kills mdmon if it was started manually by user
Date: Sun, 23 Oct 2011 01:00:36 -0700
Message-ID: <CAA9_cmfhUyenz2B1=wDsUtKcrj-5uOURproUemje37bPpM4-Qw@mail.gmail.com>
References: <20101204121413.GC11336@mother.pipebreaker.pl>
	<AANLkTi=nTSdHc55f08G9sdEK6u8eXp276VOTHHr0jmXT@mail.gmail.com>
	<20110125034434.GC7046@tango.0pointer.de>
	<AANLkTik189VTXYpzLFqP=MNBg=Nx-Yq6BOKURtiby++B@mail.gmail.com>
	<20110125042814.GA9727@tango.0pointer.de>
	<AANLkTik7dd5SHkuBVrS6LLDR9v57GsFjjxDKQKPp-YVL@mail.gmail.com>
	<20110208094843.GD11446@tango.0pointer.de>
	<AANLkTi=rFoqBwKdd0B3Xx6JrGdJdut0a2r=wFh0oSx73@mail.gmail.com>
	<20110208110730.GF23157@tango.0pointer.de>
	<AANLkTinmO9gsJcwr+0bGGuVJfF2dyM5rDJqqSkmh_hqs@mail.gmail.com>
	<20110208172822.GC21847@tango.0pointer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110208172822.GC21847@tango.0pointer.de>
Sender: linux-raid-owner@vger.kernel.org
To: Lennart Poettering <lennart@poettering.net>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, Tomasz Torcz <tomek@pipebreaker.pl>, systemd-devel@lists.freedesktop.org, linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

On Tue, Feb 8, 2011 at 9:28 AM, Lennart Poettering
<lennart@poettering.net> wrote:
> On Tue, 08.02.11 16:54, Andrey Borzenkov (arvidjaar@mail.ru) wrote:
>
>> >> a) mdmon is perfectly capable of restarting, it is already used to
>> >> take over mdmon launched in initrd. The problem is to know when to
>> >> restart - i.e. when respective libraries are changed. This is a job
>> >> for package management in distribution. It is already employed for
>> >> glibc, systemd and some others and can just as well be employed for
>> >> mdmon. And this is totally unrelated to systemd :)
>> >
>> > Really, you are sying there is a synchronous way to make mdmon reexec
>> > itself? How does that work?
>> >
>>
>> I am not sure whether it qualifies as synchronous, but "mdmon
>> --takeover" will kill any existing mdmon for this and start monitoring
>> itself.
>
> I wonder if this is really fully synchronous, i.e. that a) there is no
> point in time where mdmon is not running during this restart and b) the
> mdmom --takeover command returns when the new daemon is fully up, and
> not right-away.
>
>> > Well, the root file systems cannot be unmounted, only remounted.
>> >
>> > So, is there a way to invoke mdmon so that it flushes all metadata
>> > changes to disk and immediately terminates then this should be all we
>> > need for a clean solution. We'd then shutdown the normal instances of
>> > mdmon down like any other daemon and simply invoke this metadata
>> > flushing command as part of late shutdown.
>>
>>
>> Hmm ... it looks like you just need to
>>
>> start mdmon
>> do mdadm --wait-clean
>>
>> After this you can kill mdmon again (assuming decide is no more in
>> use).
>
>
> Well, it would be nice if the md utils would offer something doing this
> without spawning multiple processes and killing them again.
>

/me wonders why his raid5 resyncs every boot on Fedora 15 and has
found this old thread.

I'm tempted to:

1/ teach ignore_proc() to scan for pid files in /dev/md/ (MDMON_DIR on Fedora)
2/ arrange for mdadm --wait-clean --scan to be called after all
filesytems have been mounted read only

...but a few things strike me.  This does not seem to be what was
being proposed above.  Systemd does not treat dm devices like a
service and takes care to shut them down explicitly (but in that case
there is an api that it can call).  Is it time for a libmd.so,  so
systemd can invoke the "--wait-clean --scan" process itself?  Probably
simpler to just SIGTERM mdmon and wait for it.

--
Dan
