From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [mdadm git pull] support for removed disks / imsm updates
Date: Wed, 4 Mar 2009 16:59:27 -0700
Message-ID: <e9c3a7c20903041559udc4df4cpb4f2a8b63f4d08ad@mail.gmail.com>
References: <1235779532.26302.32.camel@dwillia2-linux.ch.intel.com>
	 <18863.943.962566.542421@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18863.943.962566.542421@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, Jacek Danecki <jacek.danecki@intel.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On Wed, Mar 4, 2009 at 3:41 PM, Neil Brown <neilb@suse.de> wrote:
> On Friday February 27, dan.j.williams@intel.com wrote:
>> 2/ Support for handling removed disks as currently all container
>> manipulations fail once a live disk is hot-unplugged.
>
> So this is when md thinks the device is in the array, but the device
> has actually been removed so with the block/dev file is missing or
> empty, or the status is not 'online'..
>
> But we only check for that if mdmon is running. =A0For some reason th=
at
> seems odd, but I'm not really sure.
> Why do we want to treat this case differently depending on whether
> mdmon is running or not?

The thinking, dubious or otherwise, is that if mdmon is not running
then the administrator is in charge of managing the container, and
would want to know about these errors.  I could not convince myself
that we *always* wanted to ignore missing disks here... so I erred
conservative.

However, we have already found another location where SKIP_GONE_DEVS
is needed, so part of me wonders about just making it the default?

>> 3/ An initial mdmon man page
>> 4/ imsm auto layout support
>> 5/ Updates to --incremental in pursuit of assembling external metada=
ta
>> arrays in the initramfs via udev events
>
> Thanks.
>
> Most look good.
> My attention was caught by Create: wait_for container creation.
>
> I vaguely remember trying that and it didn't work. =A0Something about
> the md array not being in the right sort of state for udev to create =
a
> device, or something... =A0But I expect you have tested it so maybe I=
'm
> remembering something else.

It corrected a test script failure here fwiw, but will keep an eye out
for container creation deadlocks.

>>
>> The one "fix" that is missing from this update is to teach mdmon to =
kick
>> "non-fresh" drives similar to what the kernel does at initial assemb=
ly.
>> I dropped the attempt after realizing I would need to take an O_EXCL
>> open on the container in an awkward place. =A0I guess it is not nece=
ssary,
>> but it is a quirk of containers that known failed drives can be allo=
wed
>> back into the container.
>
> I always thought it was a slightly odd quirk that if you had an array
> with failed drives, then stopped and restarted the array, those faile=
d
> drives would no longer be there.
> My feeling is that it doesn't matter a great deal one way or the
> other. =A0The important thing is that when mdadm describes the state =
of
> an array, it describes it in a way that doesn't confuse people (an
> area in which v1.x metadata lets us down at the moment).

Ok, that clarifies things...

[..]
> For now, all these patches have been pulled and pushed to neil.brown.=
name/mdadm

Thanks!

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
