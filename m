From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: VERY slow mdadm recovery speed 12KB/s
Date: Fri, 5 Mar 2010 00:55:50 -0800
Message-ID: <4877c76c1003050055n69ec0f71l764e7384efda1a2@mail.gmail.com>
References: <a889ac7d1003042123x7473976dw8ffe2af6f2844afc@mail.gmail.com>
	 <a889ac7d1003042127j3c3e7928y107126aff1c9a6e8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a889ac7d1003042127j3c3e7928y107126aff1c9a6e8@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Benjamin Kingston <ben@bencloud.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

md_d0 is a side-effect of trying to auto-run a conflictingly numbered
device, or non-native host (from a computer with a different hostname)
array.  Otherwise the device is exactly as normal.  If you enumerate
your arrays, even only by UUID and the device name/number you want in
/etc/mdadm.conf it will be obeyed.

Unfortunately I have no clue why your recovery is going so slowly.

Please post:

cat /etc/mdadm.conf
mdadm -Esvv

Possibly also the contents of

dmesg

if it seems even remotely relevant, and also:

for ii in /sys/block/md*/md/sync_speed* ; do \
echo -n "$ii " ; cat $ii ; done

On Thu, Mar 4, 2010 at 9:27 PM, Benjamin Kingston <ben@bencloud.net> wr=
ote:
> I did some musical HDDs to get my "best" drives to hold a critical md
> device, then one failed after a power surge. So I bought a new disk
> and added it, then accidentally marked it as failed in the middle of
> recovery. I then removed the disk and added it again. I got the
> message "/dev/sdd re-added to /dev/md1"
>
> When I do a cat /proc/mdstat the recovery speed is at 55KB/s and
> subsequent views of /proc/mdstat show that the speed goes all the way
> to 12KB/s or lower. I've since removed and re-added the drive a few
> times, but the same thing happens every time and if I leave everythin=
g
> alone while it resyncs, my CPU usage sky rockets to something like
> 16.8 23.4 40.5.
>
> Any help would be really appreciated as I don't want to loose the
> "good" drive. I know both have good speeds, because I can write at
> 4MB/s to ext4/luks on md1 and 15MB/s on /dev/sdd with dd.
>
> P.S. could someone also explain to me the difference between md0 and =
md_d0?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
