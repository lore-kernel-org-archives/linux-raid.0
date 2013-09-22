From: Phil Turmel <philip@turmel.org>
Subject: Re: raid10 recovery assistance requested
Date: Sun, 22 Sep 2013 19:25:22 -0400
Message-ID: <523F7C62.4040305@turmel.org>
References: <CA+dwz-3hWizOmbzBDBV3K4DPM1D3WUPRn_d63-FhS+5RZ-ffvQ@mail.gmail.com> <CA+dwz-2DUsx6JK=TYfKc8eGbAiHo2orhnBQv5HfOTNXAi9hv7g@mail.gmail.com> <523A7DB9.9070600@hardwarefreak.com> <CA+dwz-1=VQE1pgCctrdbvw99Qq2c_me1aYUJGU0E2sJ2Y-JdpA@mail.gmail.com> <CA+dwz-27furxUt=vQAhN8Va_gk3v545in3=kQVMG4eO5SqdCrQ@mail.gmail.com> <523F6692.9090407@turmel.org> <CA+dwz-36m6KDKbh9Gwxne8o-UyZuR2e5Z5-dKtOPS1XkA518yA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+dwz-36m6KDKbh9Gwxne8o-UyZuR2e5Z5-dKtOPS1XkA518yA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Gomboc <dave_gomboc@acm.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

[Please trim replies/avoid top-posting]

On 09/22/2013 06:45 PM, Dave Gomboc wrote:
> Yikes.  The data had been accessible on the evening of Sat. Sept 14.
> I had (apparently falsely) hoped that there were two complete copies
> of all the data, and that to restore access it would be enough to
> assign the correct drives to position 1 and 2 based on what matched
> against the contents of positions 0 and 3.

We will certainly want to inspect your drives to try to determine which
ones belong where.

> I have ran these commands on the four 4TB drives that are the copies.
> I think the smartctl -x commands in particular you want to see run
> against the original set of drives, so after sending this message, I
> will take down the machine, swap out the four copied drives for the
> four original drives, then run these commands again on the original
> drives.

Not really.  Once we start poking at the devices at a low level, the
most important thing is to keep track of drive serial numbers versus
linux device name.  I created a utility to help document a running
system [1], but that wouldn't be much help here.

> I'm not knowledgeable about the LVM backup file.  Would one typically
> happen to be stored in /boot?  That was the only directory I had that
> was not part of the raid10 system.  I had distinct logical volumes for
> home, opt, usr, var, srv, root (/), and tmp.

No, on my systems they are stored under /etc/lvm/backup/.  You don't
have your root volume, so you can only use the backup embedded in the PV
metadata.

> SCT Error Recovery Control:
>            Read: Disabled
>           Write: Disabled

While you are fixing things, you *really* need to fix this.  Consumer
drives don't wake up with this enabled, if supported at all.  You need
to set these in a boot script.  Search the archives for various
combinations of "scterc", "error recovery control", "tler", and "ure"
for a detailed explanation.

Now, please show the hex dump of your superblocks and the beginning of
the data area on each partition:

dd if=/dev/sdX1 bs=4096 skip=1 count=1 2>/dev/null |hexdump -C
dd if=/dev/sdX1 bs=4096 skip=2048 count=16 2>/dev/null |hexdump -C

And reverify which drive name in linux corresponds to which serial number.

Phil

[1] http://github.com/pturmel/lsdrv

