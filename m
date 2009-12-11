From: KueiHuan Chen <khchen@synology.com>
Subject: mdadm-3.1.1 busyloop when delete superblock on a non-exist device
	[resend]
Date: Fri, 11 Dec 2009 18:31:27 +0800
Message-ID: <788014650912110231w7bbda43ei327dd8502e6b5d3a@mail.gmail.com>
Reply-To: khchen@synology.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: Evan Tu <tsenhon@gmail.com>
List-Id: linux-raid.ids

Dear Neil,

 Due to the mail content type, so i resend mail again, sorry.

 Here has a little problem about zero superblock on a non-exist
device. We can reproduce this by the command:

  mdadm --zero-superblock /dev/sdgg

   The problem comes from Kill always return 1 when there is no such
device, and the while loop in mdadm.c is waiting for rv == 2. So it
just keep looping.

Thanks.

Best Regards,
KueiHuan-Chen
