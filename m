From: Mike Hartman <mike@hartmanipulation.com>
Subject: Re: RAID showing all devices as spares after partial unplug
Date: Sat, 17 Sep 2011 18:16:27 -0400
Message-ID: <CAB=7dhmFQ=Rtagj2j_22cnoS0A2yoKvJgaTM+ZiqDBqhPRooDQ@mail.gmail.com>
References: <CAB=7dhk0AV1dKL2cngt1eZXJwCVrfixfLE5z=J1i-7tqdL-6QA@mail.gmail.com>
	<CAB=7dhn6+QDrYReDcxTViqe6rxgkxaHeWNQ7PCUq3S3F-Qgyqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB=7dhn6+QDrYReDcxTViqe6rxgkxaHeWNQ7PCUq3S3F-Qgyqg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I should add that the mdadm command in question actually ends in
/dev/md0, not /dev/md3 (that's for another array). So the device name
for the array I'm seeing in mdstat DOES match the one in the assemble
command.

On Sat, Sep 17, 2011 at 4:39 PM, Mike Hartman <mike@hartmanipulation.co=
m> wrote:
> I have 11 drives in a RAID 6 array. 6 are plugged into one esata
> enclosure, the other 4 are in another. These esata cables are prone t=
o
> loosening when I'm working on nearby hardware.
>
> If that happens and I start the host up, big chunks of the array are
> missing and things could get ugly. Thus I cooked up a custom startup
> script that verifies each device is present before starting the array
> with
>
> mdadm --assemble --no-degraded -u 4fd7659f:12044eff:ba25240d:
> de22249d /dev/md3
>
> So I thought I was covered. In case something got unplugged I would
> see the array failing to start at boot and I could shut down, fix the
> cables and try again. However, I hit a new scenario today where one o=
f
> the plugs was loosened while everything was turned on.
>
> The good news is that there should have been no activity on the array
> when this happened, particularly write activity. It's a big media
> partition and sees much less writing then reading. I'm also the only
> one that uses it and I know I wasn't transferring anything. The syste=
m
> also seems to have immediately marked the filesystem read-only,
> because I discovered the issue when I went to write to it later and
> got a "read-only filesystem" error. So I believe the state of the
> drives should be the same - nothing should be out of sync.
>
> However, I shut the system down, fixed the cables and brought it back
> up. All the devices are detected by my script and it tries to start
> the array with the command I posted above, but I've ended up with
> this:
>
> md0 : inactive sdn1[1](S) sdj1[9](S) sdm1[10](S) sdl1[11](S)
> sdk1[12](S) md3p1[8](S) sdc1[6](S) sdd1[5](S) md1p1[4](S) sdf1[3](S)
> sdh1[0](S)
> =A0=A0=A0=A0=A0 16113893731 blocks super 1.2
>
> Instead of all coming back up, or still showing the unplugged drives
> missing, everything is a spare? I'm suitably disturbed.
>
> It seems to me that if the data on the drives still reflects the
> last-good data from the array (and since no writing was going on it
> should) then this is just a matter of some metadata getting messed up
> and it should be fixable. Can someone please walk me through the
> commands to do that?
>
> Mike
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
