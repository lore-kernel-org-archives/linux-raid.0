From: Benjamin Kingston <ben@bencloud.net>
Subject: VERY slow mdadm recovery speed 12KB/s
Date: Thu, 4 Mar 2010 22:27:49 -0700
Message-ID: <a889ac7d1003042127j3c3e7928y107126aff1c9a6e8@mail.gmail.com>
References: <a889ac7d1003042123x7473976dw8ffe2af6f2844afc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a889ac7d1003042123x7473976dw8ffe2af6f2844afc@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I did some musical HDDs to get my "best" drives to hold a critical md
device, then one failed after a power surge. So I bought a new disk
and added it, then accidentally marked it as failed in the middle of
recovery. I then removed the disk and added it again. I got the
message "/dev/sdd re-added to /dev/md1"

When I do a cat /proc/mdstat the recovery speed is at 55KB/s and
subsequent views of /proc/mdstat show that the speed goes all the way
to 12KB/s or lower. I've since removed and re-added the drive a few
times, but the same thing happens every time and if I leave everything
alone while it resyncs, my CPU usage sky rockets to something like
16.8 23.4 40.5.

Any help would be really appreciated as I don't want to loose the
"good" drive. I know both have good speeds, because I can write at
4MB/s to ext4/luks on md1 and 15MB/s on /dev/sdd with dd.

P.S. could someone also explain to me the difference between md0 and md_d0?
