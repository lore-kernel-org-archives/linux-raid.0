From: Patrick Dung <mpatdung@gmail.com>
Subject: Feature request, resumable raid check action
Date: Wed, 30 Nov 2016 20:21:55 +0800
Message-ID: <CAEtPA0Aosn6q0pJxsh69EpHQehiSsyeyVfJf98cDhu6kORkE1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

As I know if MD raid is using the newer metadata version, it support
resumable raid rebuild/sync. (that is, if a server is rebooted during
rebuild, it would resume from last position after reboot, instead of
starting from beginning).

In my recently testing (a few months ago):
I sometimes use the mdadm 'check' action for doing the disk scrubbing
of a MD raid.
After I rebooted the server, the 'check' operation is forgotten and is
not resumable.

I think resumable 'check' operation is useful as the array size would
become bigger in the future.

Thanks and regards,
Patrick
