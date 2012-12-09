From: g.esp@free.fr
Subject: Test suite result with 3.4.23-rc1
Date: Sun, 9 Dec 2012 23:43:56 +0100 (CET)
Message-ID: <985219241.117232510.1355093036748.JavaMail.root@zimbra33-e6.priv.proxad.net>
References: <1268818989.117216368.1355092191949.JavaMail.root@zimbra33-e6.priv.proxad.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1268818989.117216368.1355092191949.JavaMail.root@zimbra33-e6.priv.proxad.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello

I try to run mdadm test suite and have many tests failure with both mdadm-3.2.6 and git version.
This was run on x86 on a cpu with only one core (AMD XP2800+). The distrib is debian stable except the kernel (3.4.23-rc1).
package is compiled with
make CXFLAGS="-O2" MAP_DIR='/var/run/mdadm' FAILED_SLOTS_DIR='/var/run/mdadm/failed-slots' test

mdadm-3.2.6 fail (and stop) at tests/07changelevels

As git version support --keep-going, test suite give the following result :

sudo ./test --keep-going
Testing on linux-3.4.23-rc1 kernel
tests/00linear... succeeded
tests/00multipath... succeeded
tests/00raid0... succeeded
tests/00raid1... succeeded
tests/00raid10... succeeded
tests/00raid4... succeeded
tests/00raid5... succeeded
tests/00raid6... succeeded
tests/01r1fail... succeeded
tests/01r5fail... succeeded
tests/01r5integ... succeeded
tests/01raid6integ... succeeded
tests/02lineargrow... succeeded
tests/02r1add... succeeded
tests/02r1grow... succeeded
tests/02r5grow... succeeded
tests/02r6grow... succeeded
tests/03r0assem... succeeded
tests/03r5assem... succeeded
tests/03r5assemV1... succeeded
tests/04r0update... succeeded
tests/04r1update... succeeded
tests/05r1-add-internalbitmap... succeeded
tests/05r1-add-internalbitmap-v1a... succeeded
tests/05r1-add-internalbitmap-v1b... succeeded
tests/05r1-add-internalbitmap-v1c... succeeded
tests/05r1-bitmapfile... succeeded
tests/05r1-grow-external... succeeded
tests/05r1-grow-internal... succeeded
tests/05r1-grow-internal-1... succeeded
tests/05r1-internalbitmap... succeeded
tests/05r1-internalbitmap-v1a... succeeded
tests/05r1-internalbitmap-v1b... succeeded
tests/05r1-internalbitmap-v1c... succeeded
tests/05r1-n3-bitmapfile... succeeded
tests/05r1-re-add... succeeded
tests/05r1-re-add-nosuper... succeeded
tests/05r1-remove-internalbitmap... succeeded
tests/05r1-remove-internalbitmap-v1a... succeeded
tests/05r1-remove-internalbitmap-v1b... succeeded
tests/05r1-remove-internalbitmap-v1c... succeeded
tests/05r5-bitmapfile... succeeded
tests/05r5-internalbitmap... succeeded
tests/05r6-bitmapfile... succeeded
tests/06name... succeeded
tests/06r5swap... succeeded
tests/06sysfs... succeeded
tests/06update-uuid... succeeded
tests/06wrmostly... succeeded
tests/07autoassemble... succeeded
tests/07autodetect... succeeded
tests/07changelevelintr... succeeded
tests/07changelevels... FAILED - see /var/tmp/log-07changelevels for details
tests/07layouts... succeeded
tests/07reshape5intr... FAILED - see /var/tmp/log-07reshape5intr for details
tests/07testreshape5... succeeded
tests/08imsm-overlap... FAILED - see /var/tmp/log-08imsm-overlap for details
tests/09imsm-assemble... FAILED - see /var/tmp/log-09imsm-assemble for details
tests/09imsm-create-fail-rebuild... FAILED - see /var/tmp/log-09imsm-create-fail-rebuild for details
tests/10ddf-create... FAILED - see /var/tmp/log-10ddf-create for details
tests/11spare-migration... FAILED - see /var/tmp/log-11spare-migration for details
tests/12imsm-r0_2d-grow-r0_3d... FAILED - see /var/tmp/log-12imsm-r0_2d-grow-r0_3d for details
tests/12imsm-r0_2d-grow-r0_4d... FAILED - see /var/tmp/log-12imsm-r0_2d-grow-r0_4d for details
tests/12imsm-r0_2d-grow-r0_5d... FAILED - see /var/tmp/log-12imsm-r0_2d-grow-r0_5d for details
tests/12imsm-r0_3d-grow-r0_4d... FAILED - see /var/tmp/log-12imsm-r0_3d-grow-r0_4d for details
tests/12imsm-r5_3d-grow-r5_4d... FAILED - see /var/tmp/log-12imsm-r5_3d-grow-r5_4d for details
tests/12imsm-r5_3d-grow-r5_5d... FAILED - see /var/tmp/log-12imsm-r5_3d-grow-r5_5d for details
tests/13imsm-r0_r0_2d-grow-r0_r0_4d... FAILED - see /var/tmp/log-13imsm-r0_r0_2d-grow-r0_r0_4d for details
tests/13imsm-r0_r0_2d-grow-r0_r0_5d... FAILED - see /var/tmp/log-13imsm-r0_r0_2d-grow-r0_r0_5d for details
tests/13imsm-r0_r0_3d-grow-r0_r0_4d... FAILED - see /var/tmp/log-13imsm-r0_r0_3d-grow-r0_r0_4d for details
tests/13imsm-r0_r5_3d-grow-r0_r5_4d... FAILED - see /var/tmp/log-13imsm-r0_r5_3d-grow-r0_r5_4d for details
tests/13imsm-r0_r5_3d-grow-r0_r5_5d... FAILED - see /var/tmp/log-13imsm-r0_r5_3d-grow-r0_r5_5d for details
tests/13imsm-r5_r0_3d-grow-r5_r0_4d... FAILED - see /var/tmp/log-13imsm-r5_r0_3d-grow-r5_r0_4d for details
tests/13imsm-r5_r0_3d-grow-r5_r0_5d... FAILED - see /var/tmp/log-13imsm-r5_r0_3d-grow-r5_r0_5d for details
tests/14imsm-r0_3d_no_spares-migrate-r5_3d... FAILED - see /var/tmp/log-14imsm-r0_3d_no_spares-migrate-r5_3d for details
tests/14imsm-r0_3d-r5_3d-migrate-r5_4d-r5_4d... FAILED - see /var/tmp/log-14imsm-r0_3d-r5_3d-migrate-r5_4d-r5_4d for details
tests/14imsm-r0_r0_2d-takeover-r10_4d... FAILED - see /var/tmp/log-14imsm-r0_r0_2d-takeover-r10_4d for details
tests/14imsm-r10_4d-grow-r10_5d... FAILED - see /var/tmp/log-14imsm-r10_4d-grow-r10_5d for details
tests/14imsm-r10_r5_4d-takeover-r0_2d... FAILED - see /var/tmp/log-14imsm-r10_r5_4d-takeover-r0_2d for details
tests/14imsm-r1_2d-grow-r1_3d... FAILED - see /var/tmp/log-14imsm-r1_2d-grow-r1_3d for details
tests/14imsm-r1_2d-takeover-r0_2d... FAILED - see /var/tmp/log-14imsm-r1_2d-takeover-r0_2d for details
tests/14imsm-r5_3d-grow-r5_5d-no-spares... FAILED - see /var/tmp/log-14imsm-r5_3d-grow-r5_5d-no-spares for details
tests/14imsm-r5_3d-migrate-r4_3d... FAILED - see /var/tmp/log-14imsm-r5_3d-migrate-r4_3d for details
tests/15imsm-r0_3d_64k-migrate-r0_3d_256k... FAILED - see /var/tmp/log-15imsm-r0_3d_64k-migrate-r0_3d_256k for details
tests/15imsm-r5_3d_4k-migrate-r5_3d_256k... FAILED - see /var/tmp/log-15imsm-r5_3d_4k-migrate-r5_3d_256k for details
tests/15imsm-r5_3d_64k-migrate-r5_3d_256k... FAILED - see /var/tmp/log-15imsm-r5_3d_64k-migrate-r5_3d_256k for details
tests/15imsm-r5_6d_4k-migrate-r5_6d_256k... FAILED - see /var/tmp/log-15imsm-r5_6d_4k-migrate-r5_6d_256k for details
tests/15imsm-r5_r0_3d_64k-migrate-r5_r0_3d_256k... FAILED - see /var/tmp/log-15imsm-r5_r0_3d_64k-migrate-r5_r0_3d_256k for details
tests/16imsm-r0_3d-migrate-r5_4d... FAILED - see /var/tmp/log-16imsm-r0_3d-migrate-r5_4d for details
tests/16imsm-r0_5d-migrate-r5_6d... FAILED - see /var/tmp/log-16imsm-r0_5d-migrate-r5_6d for details
tests/16imsm-r5_3d-migrate-r0_3d... FAILED - see /var/tmp/log-16imsm-r5_3d-migrate-r0_3d for details
tests/16imsm-r5_5d-migrate-r0_5d... FAILED - see /var/tmp/log-16imsm-r5_5d-migrate-r0_5d for details
tests/18imsm-1d-takeover-r0_1d... FAILED - see /var/tmp/log-18imsm-1d-takeover-r0_1d for details
tests/18imsm-1d-takeover-r1_2d... FAILED - see /var/tmp/log-18imsm-1d-takeover-r1_2d for details
tests/18imsm-r0_2d-takeover-r10_4d... FAILED - see /var/tmp/log-18imsm-r0_2d-takeover-r10_4d for details
tests/18imsm-r10_4d-takeover-r0_2d... FAILED - see /var/tmp/log-18imsm-r10_4d-takeover-r0_2d for details
tests/18imsm-r1_2d-takeover-r0_1d... FAILED - see /var/tmp/log-18imsm-r1_2d-takeover-r0_1d for details
tests/19raid6auto-repair... FAILED - see /var/tmp/log-19raid6auto-repair for details
tests/19raid6repair... FAILED - see /var/tmp/log-19raid6repair for details
tests/19repair-does-not-destroy... succeeded

Are those tests failure know?

Gilles
