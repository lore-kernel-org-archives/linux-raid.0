From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Recovering RAID Volumes from 6 Disks
Date: Wed, 20 Jul 2016 16:36:15 +0100
Message-ID: <578F9A6F.3050503@youngman.org.uk>
References: <CADsVfeyiiAgxeeATrX9UqmWb+Hr3MCf2_eMPjL8hbD7Gpj5Ksg@mail.gmail.com>
 <578E8616.4000908@youngman.org.uk>
 <CADsVfeyz=KiAqSBe11jjBT-yOWpZp_eyP_BctkjvWC5UPNLXuQ@mail.gmail.com>
 <578F8B2D.5070003@youngman.org.uk> <20160720200726.2e399266@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160720200726.2e399266@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: Amit Biswas <abiswas@nyu.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20/07/16 16:07, Roman Mamedov wrote:
> On Wed, 20 Jul 2016 15:31:09 +0100 Wols Lists
> <antlists@youngman.org.uk> wrote:
>=20
>> backing up and replacing the barracudas
>=20
> Yeah especially the sdb and sdf ones, which are failing HARD right
> now.
>=20
> 5 Reallocated_Sector_Ct   0x0033   095   095   036    Pre-fail
> Always      -       7808 197 Current_Pending_Sector  0x0012   080
> 080   000    Old_age Always       -       3359 198
> Offline_Uncorrectable   0x0010   080   080   000    Old_age Offline
> -       3359
>=20
> 5 Reallocated_Sector_Ct   0x0033   072   051   036    Pre-fail
> Always      -       37616 187 Reported_Uncorrect      0x0032   001
> 001   000    Old_age Always       -       587 197
> Current_Pending_Sector  0x0012   001   001   000    Old_age Always
> -       33664 198 Offline_Uncorrectable   0x0010   001   001   000
> Old_age Offline      -       33664
>=20
OUCH!

Okay, and I don't like recommending stuff because I'm not an expert,
but you have 6 x 1TB drives, raid-10. Does that give you 1.5TB of
usable space, or 3TB? Never mind. I'm going to recommend getting 4 x
3TB drives at about =A3100 each - not nice. But you only need one to
start with.

Get that first 3TB drive. NOW. Physically replace sda in the machine,
and configure it as a single-drive mirror ( --create --devices=3D2 sda
spare).

Boot your system, run that timeout script, and try to assemble your
array with --scan --assemble --force. That SHOULD be safe. Read up and
make certain - I accept no responsibility for your data ...

If that works, you can now mount your array(s). READ ONLY.

Now copy your data across to the new drive - use something like rsync
or cp and keep a log - there's a high probability you'll get read
errors, and you don't want this to crash the copy and leave it only
partly complete, and you also want to know what failed.

You can now bring the system up on the new drive.

DUMP THE BARRACUDAS - ALL OF THEM. Two are failing, and the third one
is probably no better - it's not worth risking your data. The
constellations are probably okay as backup drives - it's a couple of
quid for an enclosure to turn them into usb drives :-)

As soon as you can, get the other three 3TB drives. The first of these
is urgent - your system will be running on a degraded mirror and you
need to fix that asap. The second drive will convert your mirror to
raid5, and the last one will convert it to raid6.

NB - I can't remember - is your boot/system partition on these drives?
You're better off running that as a mirror regardless, so if so, split
the 3TB drives into a small boot/system partition and a large data
partition, raid6 the data as you get the drives, and raid1 the
boot/system across all four drives (install grub on all four, too).

Cheers,
Wol
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
