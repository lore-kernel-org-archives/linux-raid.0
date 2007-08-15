From: David Greaves <david@dgreaves.com>
Subject: Re: Moving RAID distro
Date: Wed, 15 Aug 2007 18:34:09 +0100
Message-ID: <46C33911.7060108@dgreaves.com>
References: <622273920708150906t196689c8l48836b170986a713@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <622273920708150906t196689c8l48836b170986a713@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Grundy <richguk@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Richard Grundy wrote:
> Hello,
>=20
> I was just wonder if it's possible to move my RAID5 array to another
> distro, same machine just a different flavor of Linux.
Yes.

The only problem will be if it is the root filesystem (unlikely).


> Would it just be a case of running:
>=20
> sudo mdadm --create --verbose /dev/md0 --level=3D5 =96raid-devices=3D=
5
> /dev/sdb /dev/sdc etc

No
That's kinda dangerous since it overwrites the superblocks (it prompts =
first).=20
If you make the slightest error in, eg, the order of the devices (which=
 may be=20
different under a new kernel since modules may load in a different orde=
r etc)=20
then you'll end up back here asking about recovering from a broken arra=
y (which=20
you can do but you don't want to.)


> Or do I need to run some other command.

yes
You want to use mdadm --assemble

It's quite possible that your distro will include mdadm support scripts=
 that=20
will find and assemble the array automatically.

David
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
