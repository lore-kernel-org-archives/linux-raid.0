From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Removing drives
Date: Thu, 4 Mar 2010 14:45:35 -0800
Message-ID: <4877c76c1003041445g2ac9aaf6ua5fac64db975da1@mail.gmail.com>
References: <4B8F26AF.7080308@vorgon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B8F26AF.7080308@vorgon.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Timothy D. Lenz" <tlenz@vorgon.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Mar 3, 2010 at 7:19 PM, Timothy D. Lenz <tlenz@vorgon.com> wrot=
e:
> Some time back I started setting up a couple of vdr computers with ra=
id. The
> one with 3 500gb drives, I setup 2 raid 1 partitions with 1 spare fo =
boot
> and swap and used the rest of the 3 drives for a raid5 array. I had p=
roblems
> getting it to boot, and it was advised to change the raid 1 arrays to=
 3
> mirror which I did. Bu I got busy with other things and never tried t=
o
> switch it to boot from the arrays. Since then I aquired a 4th drive s=
ame
> size and model. I want to change md0/1 back to 2 drive mirrors and ch=
ange
> md2 from raid5 to raid1 freeing up a drive which I then want use to w=
ith the
> new drive to create another raid1 array. Before I can install the new=
 drive,
> I need to get it booting from md0 so I can remove the old ide drive.
>
> I figure I need to shrink md0 and md1 and then fail the 3rd drive in =
each of
> those 2 arrays before changing them to 2 drive arrays? I find lots of=
 stuff
> about adding drives, but not much about removing the drives or how to=
 change
> them back to 2 drive arrays.
>
> Once md0 and md1 are back to 2 drives and it's booting, then I'll ins=
tall
> and format the new drive and copy the contents of md2 over. Then I ne=
ed to
> remake md2 as a 2 drive raid1. Then copy the data back and i'll have =
2
> drives to make md3.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Let's divide that problem up in to more manageable chunks.

1) Boot - This is small and trivial to backup and restore.
2) Swap - Not often /required/ and thus can be disabled and erased.
3) Raid5 - Your data, which you want to convert from Raid5 to Raid1 sto=
rage.

The absolute easiest (and safest) thing to do is to backup your data,
verify the backup, then erase all the disks and start clean.

Otherwise the issues will have to be handled in the listed order:

1) Boot
If you are using 'Grub 2' (non grub legacy) then it wants EITHER mdadm
label 0.90 OR the option beneath.
Otherwise you must use mdadm label format 0.90 or, IIRC 1.0 (metadata
at the end of the area), and specify the device not as /dev/mdX but as
one of the member devices.  You will have to manually mirror or
duplicate the install sections.

2) swapoff, mdadm -S the device

3) Maybe someone else can help with the takeover?  In any event we DO
need more directions.  You're trying to go from 2 usable drives worth
of storage to 1, which isn't going to work.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
