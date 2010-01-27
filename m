From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Subject: Re: How can I tell what drive is sdb?
Date: Wed, 27 Jan 2010 14:30:34 +0000
Message-ID: <73e903671001270630j4d0f6d12tf78ee870622bb8c3@mail.gmail.com>
References: <1264601024.29409.19.camel@thor>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1264601024.29409.19.camel@thor>
Sender: linux-raid-owner@vger.kernel.org
To: Rick Bragg <lists@gmnet.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jan 27, 2010 at 2:03 PM, Rick Bragg <lists@gmnet.net> wrote:
> Hi,
>
> I have a system with raid10 running Ubuntu 8.10. =A0It uses a
> "promise"card
>
> # lsusb
> ..
> 01:02.0 Mass storage controller: Promise Technology, Inc. PDC40718 (S=
ATA
> 300 TX4) (rev 02)
> ..
>
> I have 4 identical disks on it and they show up as /dev/sda, b, c, an=
d
> d.
>
> However, sdb needs to be replaced. =A0How can I tell which drive is s=
db?
> Is there a way to identify what drive is what?
>
> Thanks
> Rick
>

I think you can use the wonderful 'lshw' utility for this. It tells
you what serial numbers the disks have, and then you can look at the
labels on the drives to see which one has what serial number.

If this doesn't work out, you can PROBABLY stop the array and PROBABLY
hotswap the disks in and out, running 'watch -n0 -d "dmesg | tail"' to
see what the kernel says. It will tell you what drive you have just
unplugged. But if you do this - BE CAREFUL - and I can't vouch that
this is OK as I've never done this. I'm only guessing at theory.

Good luck!

-- Kristleifur
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
