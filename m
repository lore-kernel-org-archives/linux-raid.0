From: Paul Dann <pdgiddie@gmail.com>
Subject: mdadm RAID1 -> 5 conversion safety
Date: Wed, 5 Feb 2020 11:51:06 +0000
Message-ID: <CALZj-VqNACF+Dn5rBrLaVmvVE2weOAjqtvWpwKU7sE=72nyvXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi there,

I've got a load of data on an md RAID 1 array assembled from 2x4TB
disks. I'm looking to expand this by adding a third 4TB disk and
converting the array to RAID 5. Now the required procedure is
documented on the wiki, but my question is:

When I convert the RAID 1 array to RAID 5, the array will be in a
degraded state as it rebuilds onto the new disk. However, if one of
the original two disks were to fail during this procedure, is mdadm
smart enough to convert the array back to degraded RAID 1, or will my
array now be a broken RAID 5 with no path to recovery?

Many thanks,
Paul
