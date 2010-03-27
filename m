From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: metadata 1.2
Date: Sat, 27 Mar 2010 14:10:16 -0700
Message-ID: <4877c76c1003271410w3ee70d44o653976b5b224ee3c@mail.gmail.com>
References: <20100326194352.GA2474@lazy.lzy>
	 <4877c76c1003261849k9219c1eq7e8ebde088b619df@mail.gmail.com>
	 <20100327091658.GA2333@lazy.lzy>
	 <4877c76c1003270231j58767878w77886a1226fa33a2@mail.gmail.com>
	 <20100327094713.GA2537@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100327094713.GA2537@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Mar 27, 2010 at 2:47 AM, Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:
> Hi,
>
>> I forget the commands, but the key thing for grub2 is stuffing all o=
f
>> the modules you need in to a single loadable image, and invoking the
>> grub2 install command to embed THAT image. =A0It's then supposed to
>
> exactly, THAT image is 28K and grub-install complains
> there is no space, basically...
> Actually, the complain is different, but the meaning
> is that grub2 cannot do it.
>
> The problem is grub2 wants to have its own things
> outside the filesystem/lvm/raid containers.
> Which is OK, but it requires also space somewhere
> in the disk.
> Standard option is to use the 32K left by tools
> like fdisk, which put the beginning of the first
> partition, by default, at sector 63.
>
> Of course it is a bit silly to have a single
> partition on a disk just to leave 32K free for
> the bootmanager.
> Not that this makes any damage, but it would be
> more clean, i.e. less tools to deal with, to
> avoid the partitioning completely.
> This would require enough space for the bootmanager
> to put its stuff.
>
> That's why I was surprised that 1.2 leaves *only* 4K
> without, apparently, any chance of having more space.
>
>> In any event, the 4k offset code is still useful for raid 1 arrays,
>
> How about changing it to something else?
>
> Thanks,
>
> bye,
>
> --
>
> piergiorgio
>

That's an entirely different question: Why only 4k and not more space?

The answer is that ~4k is the 'standard' offset for virtually every
filesystem that actually has an offset.  If you look at hexdumps from
the first few K of an LVM, msdos, ext*, and many other standard
filesystems you'll find that the general trend is to either leave no
space, or approximately 4k of space.  In this way the two 'at the
start' options clearly identify the devices as both NOT empty and NOT
another driver's container.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
