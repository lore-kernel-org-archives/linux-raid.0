From: Jean de Largentaye <jean@largentaye.org>
Subject: Re: Aliens ate my superblock!
Date: Mon, 27 Dec 2010 16:51:26 +0100
Message-ID: <AANLkTimdTj5_jjEZxWPvt1dkKfhAswRE=An+V3cTbeX-@mail.gmail.com>
References: <AANLkTimzJEdHDgnKbA5rk1Jwf7471Tib-JW3akEuWbwE@mail.gmail.com>
	<4D14E9D2.6000702@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D14E9D2.6000702@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Dec 24, 2010 at 7:43 PM, Spelic <spelic@shiftmail.org> wrote:
> On 12/24/2010 06:44 PM, Jean de Largentaye wrote:
>>
>> Hi folks,
>>
>> I have a case where I lost the last ~2000 sectors of my hard drives*=
=2E
>> As that's where the 0.90 superblock is stored, those disks are no
>> longer automatically recognized by md. Apart from that part, my disk=
s
>> and other hardware is fine.
>>
>> This is a RAID6 with 6 disks, 3 of which were chomped
>>
>
> Hi Jean
> Is the chomped part writable? Otherwise you will first have to copy t=
hose
> drives elsewhere.
>
> I think the only way would be to recreate the RAID over the drives wi=
th
> --assume-clean so that no resync is made.
> (resync would destroy your data)
> Be sure to make it same size (don't use smaller partitions) and same
> superblock type.
> When recreating the array you have to correctly guess the order of de=
vices
> to make it identical to the first time you created it. Then it will b=
ecome
> readable.
> For the 3 still readable devices you can read their position number v=
ia
> mdadm --examine /dev/device =A0(it's called Array Slot)
> If you have 3 devices with unknown position number (array slot) in th=
e array
> you can try all combinations, which are 6.
> At each iteration you can try to mount readonly and see if you see
> something.
> When you have something readable you can try xfs_repair to fix it bet=
ter.
> But better to ask in the xfs mailing list first.
> If xfs is not repairable an extreme measure is to extract data with
> photorec.
> See also older posts in this ML mentioning the --assume-clean trick f=
or
> array recovery, many are from Neil Brown himself.
>
> Merry Christmas to everybody

Hi, thanks for the hint. Thanks to that I've been able to go further,
and apparently dig myself into deeper trouble. I guess the only good
thing is that this is a personal array which I won't get fired for
whacking.

Regarding writability of the chomped part, yes it is writable. I was
able to restore access to that using "hdparm -N" to restore the
original number of sectors.

Note that my RAID used the whole disks, not partitions thereof. They
are sdb through sdg.

By the way, before my first mail to the list, I had attempted to add a
drive to the array using "mdadm --add", but the drive was added as a
spare. I am still unsure whether that affected the data on that disk,
or just the superblock. Anyhow, even with that disk out, I still had 5
out of 6 drives of my raid6, so I still had breathing room.

The rest is a comedy of errors.
1) I forgot the '-e 0.90' to specify the superblock format, so mdadm
created a 1.2 superblock. I understand this superblock was created at
the beginning (offset 2048?) of the disks, further corrupting data.
2) I forgot '--chunk 64', so mdadm created an array with 512k chunks.
Nothing was readable without that

With a proper metadata format and chunk size, I was able to mount my
broken filesystem, with errors. The odd thing is that different
permutations yielded working results, which I attribute to the magic
of Galois field algebra. However I certainly corrupted my filesystem
more at this point. But first, this is what I know about the raid
slots:
0 - unknown, 1 - sdg, 2 - sdf, 3 - unknown, 4 - sdc, 5 - unknown

So I had to find where sdb, sdd and sde fit in there. As I was afraid
I had corrupted sdb by adding as a spare previously, and considering
the redundancy of raid6, I left sdb out as 'missing'. The following
permutations yielded results:
0 - missing, 1 - sdg, 2 - sdf, 3 - sdd, 4 - sdc, 5 - sde
0 - sdd, 1 - sdg, 2 - sdf, 3 - missing, 4 - sdc, 5 - sde
0 - sdd, 1 - sdg, 2 - sdf, 3 - sde, 4 - sdc, 5 - missing

On all three of these, I was able to mount the file system (without
specifying any parameters) and listing its root contents. However some
files and directories were inaccessible, with more inacessible in the
first set, and same behaviour in the last two. This is where the
comedy of errors continues:
3) I forgot the '-o ro' option to 'mount', so I suppose some IO
happened on the disks (by mount?). I can now no longer mount the file
system at all through any of the above three permutations.
4) I have (foolishly?) attempted an 'xfs_repair -n' (-n avoids
modifying the fs) to try and retrieve the secondary xfs superblock, to
no avail.

I assume either of these mistakes have tickled md into resyncing the
drives, as /proc/mdstat no longer displayed "auto-read-only" after the
xfs_repair, and I'm afraid I have corrupted my data further. I did not
run "mdadm --monitor" at any time, and I see nothing in the kernel
logs pertaining to resyncing. I can of course provide kernel logs.

At each step I've made a rookie mistake that further worsened the
situation, so at this point I'm too terrified to proceed further
without external assistance. Any more hints would be greatly
appreciated :)

John
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
