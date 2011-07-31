From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Do I have a bad HDD?
Date: Sun, 31 Jul 2011 19:31:40 +0100
Message-ID: <CADNH=7FmDpRhYbXGMJ=h17x=7hKL-=Wpoydnca=VAkLGqCfSFQ@mail.gmail.com>
References: <CADNH=7HDCwtUr-HSN7fH_GSH8jTYb-SAwmKY0ZRn3opWAhKiBQ@mail.gmail.com>
	<CADNH=7EJ7tvw2DEsAbeuxxRO1k961RSV4axgvfRUBaKG+Q455Q@mail.gmail.com>
	<CADNH=7EHAyk7Z7Wa72XO=p1od6AQP5aew_W5DffgLfZeCu=d-g@mail.gmail.com>
	<CADNH=7F3CVZ6r56jFrSHoVyzOZTHCfXPE_j-Rn8powbB6BLBYQ@mail.gmail.com>
	<4E359E26.2080500@truschnigg.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E359E26.2080500@truschnigg.info>
Sender: linux-raid-owner@vger.kernel.org
To: Johannes Truschnigg <johannes@truschnigg.info>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 31 July 2011 19:25, Johannes Truschnigg <johannes@truschnigg.info> wrote:
> Hi Mathias,
>
> PLEASE don't always quote everything you've just written a few minutes
> ago when replying to yourself. This makes these responses really, really
> inconvenient to read.
>
> Concerning your problem at hand: Don't panic, everything should be fine.
> Your RAID did what it is supposed to do: protect your from a single
> drive failure without inducing downtime. A disk has failed, and now it's
> time to replace it, that's nothing out of the ordinary. You don't need
> to shut down your system - RAID systems have "no service interruption in
> case of an accident" as a design goal, and md is rather good at meeting
> just that.
>
> If your SATA controller supports hotplug (and if it's SATA-300, that
> much is for certain), just unplug the old drive, replace it with a new
> one, clone your partition table setup (if any) from an old driver to the
> new one, have md pick up the disk and integrate it into your array, and
> see how everything'll be taken care of automatically. md will resync the
> array once the new disk is part of the array, and it will be smooth
> sailing again afterwards. Just make sure you don't pull out the wrong
> drive, but correctly identify the broken one. ;)
>
> While the array's being worked on, you can do whatever you intended to
> do with your seemingly healthy array from of a few hours ago - the only
> difference it that (some) things will go slower, but that's about it.
> The only serious problem you could run into is a second and third
> harddrive failing while your array isn't 100% OK again yet - but even in
> that case, you'd have a backup ready, now wouldn't you? :)
>
>
> --
> with best regards:
> - Johannes Truschnigg ( johannes@truschnigg.info )
>
> www: http://johannes.truschnigg.info/
> phone: +43 650 2 133337
> xmpp: johannes@truschnigg.info
>
> Please do not bother me with HTML-eMail or attachments. Thank you.
>
>

Sorry about that!

No I don't have a backup ;), perhaps it's time to get one. This isn't
super important data, more like "nice to have".

I don't have any hotplug bays or anything like that (you'll see in a
while after I put up the pictures) so I shut down the system to take
the faulty HDD out.

Is it wise to run a check on the array while it's degraded by 1 HDD?

Thanks again,
/Mathias
