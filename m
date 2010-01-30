From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: RAID5 on broken RocketRaid 1640 - data format?
Date: Fri, 29 Jan 2010 23:15:47 -0800
Message-ID: <4877c76c1001292315y16b4a8eay8e73a9d35727506d@mail.gmail.com>
References: <73e903671001291155g761f2dc8rb6e02541525929ba@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <73e903671001291155g761f2dc8rb6e02541525929ba@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Jan 29, 2010 at 11:55 AM, Kristleifur Da=F0ason
<kristleifur@gmail.com> wrote:
> Hi,
>
> A good pal of mine once had a 4x400GB RAID5 array running on a
> RocketRaid 1640 controller. The controller broke, and due to
> complexity and his understandable lack of RAID expertise, the drives
> are sitting in a drawer. I want to try to help.
>
> Do you excellent list dwellers know what data format the 1640 uses on
> the disks? Is there any Linux RAID tool that can work with the data
> off the disks?
>
> In case it's relevant, the system was running Windows, and there was =
a
> single NTFS filesystem over the array. I'm pretty sure the array was
> created on the BIOS side.
>
> Many thanks!
> -- Kristleifur
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Load the drives in to a computer as spare drives, DO NOT WRITE TO THEM
(make sure your OS doesn't try to automount either).

Try mdadm --examine on the raw devices and any partitions you can see.

If mdadm recognizes the meta-data format there is a very good chance
the array can be brought online, try to do that in read-only mode
(read the mdadm manual).

Examine the result, it may contain partitions or a filesystem that can
be mounted via something like ntfs-3g.  If you get that far I
recommend running a CHECK on the array (Before making it read/write)
and validating that there are no errors.  If you get errors you /may/
want to make a backup of the entire device.

I know that old drives from a 4-port hardware raid card I used one
time kept showing meta-data (in the syslog) unknown/not recognized,
but I don't believe it was a highpoint 1640.  There have also been
improvements since then.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
