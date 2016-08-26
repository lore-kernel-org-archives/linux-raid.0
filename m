From: Marc Smith <marc.smith@mcc.edu>
Subject: md-cluster Module Requirement
Date: Fri, 26 Aug 2016 10:40:07 -0400
Message-ID: <CAHkw+Lf82YEZ3qm9KJ_b_2pUiNFh=nDeEBXYV5PdgtEUtij8eg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm attempting to use md-cluster from Linux 4.5.2 with mdadm 3.4 and
I'm running into this when attempting to create a RAID1 device with
the clustered bitmap:

--snip--
[64782.619968] md: bind<dm-4>
[64782.629336] md: bind<dm-3>
[64782.630008] md/raid1:md127: active with 2 out of 2 mirrors
[64782.630528] md-cluster module not found.
[64782.630530] md127: Could not setup cluster service (-2)
[64782.630531] md127: bitmap file superblock:
[64782.630532]          magic: 6d746962
[64782.630533]        version: 5
[64782.630534]           uuid: 10fee18f.f553d7f2.deb926f1.c7c4bd4b
[64782.630534]         events: 0
[64782.630535] events cleared: 0
[64782.630536]          state: 00000000
[64782.630537]      chunksize: 67108864 B
[64782.630537]   daemon sleep: 5s
[64782.630538]      sync size: 878956288 KB
[64782.630539] max write behind: 0
[64782.630541] md127: failed to create bitmap (-2)
[64782.630577] md: md127 stopped.
[64782.630581] md: unbind<dm-3>
[64782.635133] md: export_rdev(dm-3)
[64782.635145] md: unbind<dm-4>
[64782.643111] md: export_rdev(dm-4)
--snip--

I'm using md-cluster built-in, not as a module:
# zcat /proc/config.gz | grep MD_CLUSTER
CONFIG_MD_CLUSTER=y

It seems the driver is attempting to load the 'md-cluster' module
(from drivers/md/md.c):
--snip--
        err = request_module("md-cluster");
        if (err) {
                pr_err("md-cluster module not found.\n");
                return -ENOENT;
        }
--snip--

I looked at linux-next and it appears this code is the same; is there
a test we can do before attempting to load the module in the case that
its built-in, or is there some other requirement that md-cluster needs
to be built as a module?

Thanks for your time.


--Marc
