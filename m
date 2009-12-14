From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [GIT PATCH 0/2] external-metadata recovery checkpointing for
	2.6.33
Date: Sun, 13 Dec 2009 21:49:07 -0700
Message-ID: <e9c3a7c20912132049g6034fbc6vf86a7bcbc323746a@mail.gmail.com>
References: <20091213041123.12532.15225.stgit@dwillia2-linux.ch.intel.com>
	 <20091214150725.49de72f1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091214150725.49de72f1@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: ed.ciechanowski@intel.com, marcin.labun@intel.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Dec 13, 2009 at 9:07 PM, Neil Brown <neilb@suse.de> wrote:
> On Sat, 12 Dec 2009 21:17:01 -0700
> Dan Williams <dan.j.williams@intel.com> wrote:
>
>> =A0 =A0 =A0 md: add 'recovery_start' sysfs attribute
>
> This one I don't like so much.
> recovery_start should be a per-device value, not a per-array value,
> and each device can theoretically have been recovered to a different =
place.
> We don't make much use of that fact, but maybe we could one day.
>
> So I have change the code to simply expose rdev->recovery_offset thro=
ugh
> sysfs, which should provide all the functionality you need.

Yes, and more flexible in the long run, ack.

> Patch below.
> It still says "From: Dan Williams" because I started with you patch
> and then changes almost all of it (but not quite all). =A0That seems =
a
> bit odd but doesn't bother me - tell me if it bothers you.

I've typically added an akpm inspired:
[foo@bar.com: made some mods]
=2E..note when I have touched other people's patches, but it's not a bi=
g
deal to me.

> +static ssize_t recovery_start_store(mdk_rdev_t *rdev, const char *bu=
f, size_t len)
> +{
> + =A0 =A0 =A0 unsigned long long recovery_start;
> +
> + =A0 =A0 =A0 if (cmd_match(buf, "none"))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 recovery_start =3D MaxSector;

Should probably do the same for resync_start to be consistent?

Thanks,
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
