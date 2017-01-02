From: Ben Kamen <benjammin2068@gmail.com>
Subject: Re: Using mdadm --grow to resize a RAID1
Date: Mon, 2 Jan 2017 11:59:44 -0600
Message-ID: <CADDTLRAY=VHydpXOUMh0OSsVYnYefKyo1vtR3hZx4vyGsSW3tQ@mail.gmail.com>
References: <4716208e-12a9-1ae8-46f4-a89ae15d9077@gmail.com>
 <586A454F.1010308@youngman.org.uk> <ca87be95-bfb1-10c6-18d4-9aca4a6e3558@gmail.com>
 <20170102212412.19832496@natsu> <e37c42da-71f5-e83e-4e9f-2ec3961a14a0@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e37c42da-71f5-e83e-4e9f-2ec3961a14a0@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Jan 2, 2017 at 10:38 AM, Benjammin2068 <benjammin2068@gmail.com> wrote:
>
>
> Yep -- sizes are off and --rereadpt returns "device busy".
>
> Be right back....
>


ok. back.

the block sizes are the same...

There's still no bitmap active (from my turning it off previously)

So I issued the command again to expand the size... and my system has
been acting weird... my access to /proc/mdstat gets stalled if I'm
watching it..

The grow command "mdadm --grow /dev/md1 --size=max" seems to be
"blocking". I don't get back a prompt to enter the --wait command (and
the final bitmap command)

I can't even CTRL-C out of it. I had to reboot once already and the
filesystem comes back up as it was. But "reboot" even gets stuck. I
have to eventually reset.

Sounds like I have to do this from single user mode or an boot disk/CD?

 -Ben
