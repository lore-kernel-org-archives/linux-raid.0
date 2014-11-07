From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: RAID 6 (containing LUKS dm-crypt) recovery help.
Date: Fri, 7 Nov 2014 10:24:45 +0000
Message-ID: <21596.40429.244605.398712@tree.ty.sabi.co.uk>
References: <545C5C9D.9000309@retard.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <545C5C9D.9000309@retard.io>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> [ ... ] The server experienced some sort of hardware event
> that resulted in a mandatory restart of the server.

Details would be helpful: because if some problem happens the
standard advice is "reload from backups". If you want to
shortcut that to mostly-recovery context matters to figuring out
how and how safely.

> [ ... ] completed the restart, the array looked like this,
> "all spares":

> md6 :

What happened to the other MD sets on the same server, if any?
Any damage? Because if those suffered no damage, there is the
possibility that the disk rack backplane holding the members of
'md6' got damaged, or the specific host adapter; and that the MD
set content is entirely undamaged and the funny stuff being read
is a transmission problem.

> inactive sdl1[7](S) sdh1[13](S) sdg1[14](S) sdk1[11](S)
> sdj1[10](S) sdi1[6](S) sdd1[2](S) sdf1[8](S) sdb1[12](S)
> sde1[3](S) sdc1[15](S) 21488638704 blocks super 1.2

"Clever" people hide details as possible, and go to such lengths
as to actually remove vital information as for example what
literally follows "super 1.2" here. Because actual quotes are
too "insipid" and paraphrases are more "challenging":

> The mdadm array has the following characteristics: RAID level:
> 6 Chunk size: 256k Version: 1.2 Number of devices: 11

How do you know? Is this part of your records or from actual
output of 'mdadm --examine'?

But assuming the above is somewhat reliable there is an
"interesting" situation: in "21488638704 blocks" the number
21,488,638,704 is not a whole multiple of 9:

  $ factor 21488638704
  21488638704: 2 2 2 2 3 13 1801 19121

> All attempts to assemble the array continued to result in the "all=20
> spare" condition (output above). Thinking that the metadata had been=20
> corrupted somehow,

Apparently without ever trying 'mdadm --detail /dev/md6' or
'mdadm --examine /dev/sd...' as per:

  https://raid.wiki.kernel.org/index.php/RAID_Recovery

> I set out to recreate the array.

Quite "brave":

  https://raid.wiki.kernel.org/index.php/RAID_Recovery
  =ABRestore array by recreating (after multiple device failure)
  Recreating should be considered a *last* resort, only to be
  used when everything else fails.
  People getting this wrong is one of the primary reasons people
  lose data. It is very commonly used way too early in the fault
  finding process. You have been warned!=BB

> The following is the dev_number fields from the metadata,
> before I attempted to recreate the array: for i in /dev/sd?1;
> do echo -n $i '' ; dd 2> /dev/null if=3D$i bs=3D1 count=3D4
> skip=3D4256 | od -D | head -n1; done: I used the following to
> extract the index position of each device on a device I
> suspected wasn't corrupted (for the record, they all returned
> the same data): [ ... ]

It is very "astute" indeed to use 'dd' instead of 'mdadm
--examine'.  For example it "encourages" people who might want
to help to spend some extra time checking your offsets, that
"teaches" them.

[ ... ]
>      Number   Major   Minor   RaidDevice State
>        12       8       17        0      active sync   /dev/sdb1
>         3       8       65        1      active sync   /dev/sde1
>         2       8       49        2      active sync   /dev/sdd1
>         8       8       81        3      active sync   /dev/sdf1
>         6       8      129        4      active sync   /dev/sdi1
>         7       8      177        5      active sync   /dev/sdl1
>         6       0        0        6      removed
>        10       8      145        7      active sync   /dev/sdj1
>        11       8      161        8      active sync   /dev/sdk1
>        13       8      113        9      active sync   /dev/sdh1
>        14       8       97       10      active sync   /dev/sdg1

> The dev_numbers and index position information in conjunction
> with the historic data (directly above) seemed to indicate
> that the proper recreation order and command would be the
> following:

> mdadm --create /dev/md6 --assume-clean --level=3D6
> --raid-devices=3D11 --metadata=3D1.2 --chunk=3D256 /dev/sdb1
> /dev/sde1 /dev/sdd1 /dev/sdf1 /dev/sdi1 /dev/sdl1 /dev/sdc1
> /dev/sdj1 /dev/sdk1 /dev/sdh1 /dev/sdg1

The main consequence of the above is that the original MD member
metadata blocks are no longer available unless something like
this has been done:

  https://raid.wiki.kernel.org/index.php/RAID_Recovery
  =ABPreserving RAID superblock information
  One of the most useful things to do first, when trying to
  recover a broken RAID array, is to preserve the information
  reported in the RAID superblocks on each device at the time
  the array went down (and before you start trying to recreate
  the array). Something like
    mdadm --examine /dev/sd[bcdefghijklmn]1 >> raid.status=BB

If you went to the lengths to write 'dd' expressions, you might
as well have saved the output of '--examine'. Perhaps you did,
but if you did not attach that output to your request for help
it would be rather "stunning".

[ ... ]

> Is the "mdadm --create" operation that I issued, incorrect?
> Have I done anything in error?

There is something strange: what you report being the output of
'--detail' from July:

      Array Size : 17581609728 (16767.13 GiB 18003.57 GB)
   Used Dev Size : 1953512192 (1863.01 GiB 2000.40 GB)

and the output of '--detail' for the re-created:

      Array Size : 17580439296 (16766.01 GiB 18002.37 GB)
   Used Dev Size : 1953382144 (1862.89 GiB 2000.26 GB)

Both numbers don't match. They are *slightly* different. In
particular it is rather strange that the "Used Dev Size" is
different. How is that possible? Have the disks shrunk a little
in the meantime? :-)

It is intriguing that the difference between 1953512192 and
1953382144 is 1024*127KiB or 1024*254 sectors.

Also I have noticed that the MD set is composed of disk of 3
different models (ST2000DL003-9VT1, ST2000DM001-1CH1,
ST32000542AS)...

> Is my data gone? Any and all insight are extremly welcomed and
> appreciated.

Whether your data is gone depends on what kind of hardware issue
you have had, and to the consequence of the "brave" '--create'
above. But also how the MD set was setup, e.g. with members of
slightly different sizes. The inconsistencies in the reported
numbers are "confusing".
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
