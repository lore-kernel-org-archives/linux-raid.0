From: Vegard Haugland <vegard@haugland.at>
Subject: Re: Help with assembling a stopped array
Date: Wed, 13 Jul 2016 21:11:55 +0200
Message-ID: <CANz1=TEdGxvDo8WRfCwQy4Ymar2Oo7Ct9acBYJcz06XpaFM15w@mail.gmail.com>
References: <CANz1=TGr3_ayX-CxcjsBx6Q0Ggh5PXp1STmqHW1XuMS8GGE7Lg@mail.gmail.com>
 <caf338d7-cc3f-0aca-e928-7619a64d888c@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <caf338d7-cc3f-0aca-e928-7619a64d888c@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Phil.

Thanks for taking your time to answer my post. I really appreciate it!

> You'll have to supply more detail.  Uncut mdadm -E /dev/sdXY for each
> member device in its current state.  smartctl -iA -l scterc /dev/sdX for
> each member device's drive.

Sure. I wrote that post at 03:23 AM local time somewhat panicked, so I
didn't think of booting a live distro to easily get the logs you
require.

Output from $ for x in /dev/sd?3; do mdadm --examine $x >> output_examine; done;

http://paste.debian.net/780968/

Output from $ for x in /dev/sd?3; do echo $x >> output_smartctl;
smartctl -iA -l scterc $x >> output_smartctl; done;

http://paste.debian.net/780967/

Note that since I booted into a live CD, the device names do no longer
match what I wrote in my original post.

> You would not believe how often we encounter reports like yours where
> more member devices fail while trying to rebuild/resync/re-add after a
> first failure.  There's some reading assignments for you at the at end
> of this mail that you *must* read and understand or this array will blow
> up again.

Of the links you posted, only the last one appeared relevant to my
problem. If your intention was that I read these to increase my
knowledge of md in general to avoid issues like mine from happening in
the future, I'm happy to oblige. There were a lot of technical terms
and details in those threads that I don't yet fully grasp, so please
bear with me while I take my time to fully digest this. Do you
recommend I read these in the suggested order?

>
> When you used --assemble --force, did you spell out exactly which
> devices to use?
>

Yes. I spelled out all the good drives and omitted the faulty ones.
The result of this was that one of the drives showed up as spare.
Also, the event counter on all drives specified incremented by one
except the spare one. The current event counters are, as shown while
booting the live CD (again, note that the device names differ from my
original post):

/dev/sda3         Events : 32680547
/dev/sdb3         Events : 32680549
/dev/sdc3         Events : 32679348
/dev/sdd3         Events : 32677935
/dev/sde3         Events : 32680549
/dev/sdg3         Events : 32680549
/dev/sdh3         Events : 32680549
/dev/sdi3         Events : 32680549
/dev/sdj3         Events : 32680549
/dev/sdk3         Events : 32680549

The "spare" (which isn't a spare) is /dev/sda3. I've attempted forcing
assembly twice with no prevail. As such, the event counter has
incremented by 2 on the good drives compared to /dev/sda. The faulty
drives are /dev/sdc3 and /dev/sdd3 as shown by the event counter.

> Boot from a modern rescueCD or USB drive that lets you save the
> requested information and output on the console.  Include any dmesg
> content that involves these devices.  When running mdadm, include the -v
> option so your console has more info for us.

Noted. Will do that from now on.

> Absolutely do not use --create!

Noted!

Again, thanks for helping out.

Vegard


-- 
Vegard Haugland <vegard@haugland.at>
Mob. +47 976 68 262
Web: www.v3gard.com | foto.haugland.at

If you want to send me encrypted email, my public GPG key is located
at http://v3gard.com/files/gpg.pub
