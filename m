From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [systemd-devel] systemd kills mdmon if it was started manually by user
Date: Tue, 8 Nov 2011 15:27:00 -0800
Message-ID: <CABE8wwusk82RX-61YjMQabf9N9t_rUb4KjGq+GM+7HV028iJpg@mail.gmail.com>
References: <20110208172822.GC21847@tango.0pointer.de>
	<CAA9_cmfhUyenz2B1=wDsUtKcrj-5uOURproUemje37bPpM4-Qw@mail.gmail.com>
	<20111031110613.GA1402@tango.0pointer.de>
	<20111102114416.7879b77f@notabene.brown>
	<20111102011615.GA5289@tango.0pointer.de>
	<20111102130334.09c3ab51@notabene.brown>
	<20111102133223.GC5119@tango.0pointer.de>
	<20111107135241.64ae261d@notabene.brown>
	<20111107120048.GD25130@tango.0pointer.de>
	<CABE8wwug4-gMLA4rd6FXgV3db2XiwUcfsXp6fC=NipKg333n-g@mail.gmail.com>
	<20111108144336.GA12609@tango.0pointer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111108144336.GA12609@tango.0pointer.de>
Sender: linux-raid-owner@vger.kernel.org
To: Lennart Poettering <lennart@poettering.net>
Cc: NeilBrown <neilb@suse.de>, Andrey Borzenkov <arvidjaar@mail.ru>, Tomasz Torcz <tomek@pipebreaker.pl>, systemd-devel@lists.freedesktop.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Nov 8, 2011 at 6:43 AM, Lennart Poettering
<lennart@poettering.net> wrote:
> On Mon, 07.11.11 11:09, Williams, Dan J (dan.j.williams@intel.com) wr=
ote:
>> So I think mdmon should always try to escape itself from cgroup base=
d
>> killing. =A0It follows the lifespan of the array, and if the array i=
s
>> not stopped by the cgroup exit (or the array lifespan is not
>> controlled in a service file), then mdmon must keep running.
>
> Well, I think when it gets killed by the cgroup-based killer then it
> should try to tear down its MD device.

We can easily fall off the complexity cliff trying to tear down the MD
device because it can be pinned by a mounted filesystem or being
claimed anywhere in an arbitrary stack of DM or MD devices.  I did not
think cgroup exit would umount() filesystems?

[..]
>> I notice that if the rootfs is on a dm or md device systemd/shutdown
>> will always fall through to ultimate_send_signal() which will not
>> discriminate against processes flagged with '@'. =A0Since we aren't
>> stopping the root md device I wonder if ultimate_send_signal() shoul=
d
>> also ignore flagged processes, or whether the failure to stop the ro=
ot
>> device is to be expected and let shutdown skip ultimate_send_signal(=
)
>> if the only remaining work is shutting down the rootfs-blockdev. =A0=
I'm
>> leaning towards the latter.
>
> The idea was to skip processes flgged with '@' in both the
> ultimate_send_signal() and send_signal() calls.

Ok, that makes it easier.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
