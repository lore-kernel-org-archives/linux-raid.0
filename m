From: =?ISO-8859-1?Q?Tor_Arne_Vestb=F8?= <torarnv@gmail.com>
Subject: Re: Linux RAID autodetect partitions go missing from /dev, but fdisk
 can see them
Date: Sun, 18 Jan 2009 18:51:38 +0100
Message-ID: <49736C2A.3050108@gmail.com>
References: <49402CFE.3080708@gmail.com>	<18759.8246.568849.244513@notabene.brown>	<494AC8BA.7010704@gmail.com> <18762.53424.819087.495066@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18762.53424.819087.495066@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi again,

Sorry for the delay (Christmas vacation, ++). I still have the problem
though.

My attempt to re-create /dev/sdb1 by fdisk'ing it again and adding it to
the array failed. That is, mdadm started re-constructing the array, and
that succeeded, but when I rebooted /dev/sdb1 was missing again :/

Neil Brown wrote:
> If a partition start at an offset in the device which is a multiple of
> 64K, and ends at the end of the device, then both the partition and
> the whole device will appear to have the same superblock.  This can
> cause confusion.

I think you are on to something here! I did partition all my disks with
just one partition, starting on the first block and taking up all the
remaining space, and set it to type Linux RAID auto detect.

Here's the output of the fdisk -pu and mdmadm -E commands before running
blockdev:

    http://pastebin.com/f4cad67ea

    http://pastebin.com/f34be2b86

It seems that mdadm thinks sd[bc] are part of the array directly
somehow, but for sd[def] the partition itself is in the array, which I
guess supports your suspicion?

Here's the output after running blockdev --rereadpt /dev/sdc :

   http://pastebin.com/f725ee0c3

Suddenly mdadm -E /dev/sdc* shows info for both sdc and sdc1, and guess
what? /dev/sdc1 is back as a device node :)

So is this a case of the problem you described about
superblock-confusion? If so, is it fixable?

Thank you so much for your help in this! I really do feel I'm one big
step closer to solving this!

Tor Arne
