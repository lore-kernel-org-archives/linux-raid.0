From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: systemd kills mdmon if it was started manually
	by user
Date: Tue, 8 Feb 2011 16:54:03 +0300
Message-ID: <AANLkTinmO9gsJcwr+0bGGuVJfF2dyM5rDJqqSkmh_hqs@mail.gmail.com>
References: <201012041012.23757.trapni@gentoo.org>
	<AANLkTikTa8stFAcXG9jknh=RG=-Mi+xW-AD9DgZCfQ=7@mail.gmail.com>
	<20101204121413.GC11336@mother.pipebreaker.pl>
	<AANLkTi=nTSdHc55f08G9sdEK6u8eXp276VOTHHr0jmXT@mail.gmail.com>
	<20110125034434.GC7046@tango.0pointer.de>
	<AANLkTik189VTXYpzLFqP=MNBg=Nx-Yq6BOKURtiby++B@mail.gmail.com>
	<20110125042814.GA9727@tango.0pointer.de>
	<AANLkTik7dd5SHkuBVrS6LLDR9v57GsFjjxDKQKPp-YVL@mail.gmail.com>
	<20110208094843.GD11446@tango.0pointer.de>
	<AANLkTi=rFoqBwKdd0B3Xx6JrGdJdut0a2r=wFh0oSx73@mail.gmail.com>
	<20110208110730.GF23157@tango.0pointer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <systemd-devel-bounces+gcssd-systemd-devel=m.gmane.org@lists.freedesktop.org>
In-Reply-To: <20110208110730.GF23157@tango.0pointer.de>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/systemd-devel>,
	<mailto:systemd-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/systemd-devel>
List-Post: <mailto:systemd-devel@lists.freedesktop.org>
List-Help: <mailto:systemd-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/systemd-devel>,
	<mailto:systemd-devel-request@lists.freedesktop.org?subject=subscribe>
Sender: systemd-devel-bounces+gcssd-systemd-devel=m.gmane.org@lists.freedesktop.org
Errors-To: systemd-devel-bounces+gcssd-systemd-devel=m.gmane.org@lists.freedesktop.org
To: Lennart Poettering <lennart@poettering.net>
Cc: linux-raid@vger.kernel.org, systemd-devel@lists.freedesktop.org
List-Id: linux-raid.ids

On Tue, Feb 8, 2011 at 2:07 PM, Lennart Poettering
<lennart@poettering.net> wrote:
> On Tue, 08.02.11 13:52, Andrey Borzenkov (arvidjaar@mail.ru) wrote:
>
>> I am probably the wrong one to ask, but here is what happens when
>> array is started (from udev perspective)
>
> [...]
>
>> After this event device goes "plugged" and SYSTEMD_WANTS (if any) are
>> triggered. But at this point we have zero information about array to
>> decide anything.
>
> [...]
>
>> At this point we know it is container, know that it has external
>> metadata and know that we need external metadata handler (mdmon). But
>> it is too late for systemd.
>
> Kay, do you know why this "change" event is used here? Any chance we can
> get rid of it?
>
>>
>> >
>> >> Actually it can be implemented even without mdadm patches; apparently
>> >> it is possible to suppress normal starting of mdmon by setting
>> >> MDADM_NO_MDMON=1
>> >
>> > A this point mdmon is simply broken: if glibc or mdmon itself (or any
>> > lib it is using) is upgraded, then mdmon will keep referencing the old
>> > .so or binary as long as it is running. This means that the fs these
>> > files are on cannot be remounted r/o. However mdmon insists on being
>> > shutdown only after all fs got remounted ro. So you have a cyclic
>> > ordering loop here: mdmon wants to be shut down after the remount, but
>> > we need to shut it down before the remount.
>> >
>>
>> Ehh ...
>>
>> a) mdmon is perfectly capable of restarting, it is already used to
>> take over mdmon launched in initrd. The problem is to know when to
>> restart - i.e. when respective libraries are changed. This is a job
>> for package management in distribution. It is already employed for
>> glibc, systemd and some others and can just as well be employed for
>> mdmon. And this is totally unrelated to systemd :)
>
> Really, you are sying there is a synchronous way to make mdmon reexec
> itself? How does that work?
>

I am not sure whether it qualifies as synchronous, but "mdmon
--takeover" will kill any existing mdmon for this and start monitoring
itself.

>> b) having binary launched off some fs should not prevent this fs to be
>> remountd ro - binaries are not opened rw
>
> If you run a binary and then the package manager replaces it then the
> running instance will still refer to the old copy and this will have the
> effect that the file isn't actually deleted until the proces
> exits/execs. And because that is the way it is the kernel will refuse
> unmounting of the fs until you terminated/reexeced your process.
>
>> > This is unfixable unless a) mdmon learns reexecution of itself without
>> > losing state (like most init systems so), or b) mdmon would stop
>> > insisting on being shutdown only after the remount.
>>
>> As far as I can tell, both is true today; but remounting is not
>> enough, unfortunately.
>
> So, you are saying we can shut down mdmon without ill effects early?
>

At least that's what I see. You can shutdown mdmon and continue to
work with file system, even if it is mounted rw. Under some conditions
mount will hang; i.e.

start array
kill mdmon
try to mount

mount will hang. If you start mdmon, it is mounted. But if you now

umount
kill mdmon
mount

it is mounted just fine.

>> > In my eyes b) is very much preferebale: It should be possible to shut
>> > down mdmon like any other service. And if then some md related code
>> > still needs to be run on late shutdown this should be done from a new
>> > process. I would be willing to add some hooks for this, so that we can
>> > execute arbitrary drop-in processes as part of the final shutdown loop.
>>
>> mdmon is needed to ensure metadata were correctly updated. So it needs
>> to exist as long as metadata *may* be updated. For practical purposes
>> it means - until file system is unmounted and flushed to disks. I am
>> not sure that remounting ro stops all activity (at least, mounting ro
>> definitely *writes* to device using some filesystems).
>
> Well, the root file systems cannot be unmounted, only remounted.
>
> So, is there a way to invoke mdmon so that it flushes all metadata
> changes to disk and immediately terminates then this should be all we
> need for a clean solution. We'd then shutdown the normal instances of
> mdmon down like any other daemon and simply invoke this metadata
> flushing command as part of late shutdown.


Hmm ... it looks like you just need to

start mdmon
do mdadm --wait-clean

After this you can kill mdmon again (assuming decide is no more in use).
