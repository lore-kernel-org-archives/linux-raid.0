From: Adrian Palmer <adrian.palmer@seagate.com>
Subject: [LSF/MM ATTEND][LSF/MM TOPIC] SMR/Zoned devices IO
Date: Fri, 29 Jan 2016 14:41:09 -0700
Message-ID: <CAKdFiL5WqKz2Pq3bAhPooO0jF_u6MY-9FFcGb-62O_atWyeqfQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
To: lsf-pc@lists.linux-foundation.org
Cc: linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-block@vger.kernel.org, Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>, linux-raid@ver.kernel.org
List-Id: linux-raid.ids

Greetings:

I would like to attend LSF/MM to continue discussion related to SMR.

Besides the SMRFFS, we've been developing a zoned device mapper (ZDM).
I would like to gather feedback and direction.  I can provide a quick
explanation of the architecture.  This will enable existing software
to work on zoned devices.  Our work will initially focus on workloads
provided by mdraid.

Also, I would like to discuss the storage of the zone information in
the kernel.  It makes little sense for the drive to be continuously
probed, or for each app to maintain it own, possibly un-synced, copy
of the zone information.  I'll bring along our work and
recommendations of a solution based on Hannes' work in this area.  I
believe we need a common stackable interface to pass along this
information, both up the kernel, and to userland.

Lastly, we are still exploring the need for an additional elevator
besides the no-op that orders not only by time, but also zone aware
location.  I'll have some test results by lsf/mm that we can discuss.


Adrian Palmer
Firmware Engineer II
R&D Firmware
Seagate, Longmont Colorado
720-684-1307
adrian.palmer@seagate.com
