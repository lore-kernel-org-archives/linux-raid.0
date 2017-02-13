From: Chien Lee <chienlee@qnap.com>
Subject: Enable the skip_copy feature will results in data integrity issue in
 raid5 degraded mode.
Date: Mon, 13 Feb 2017 17:07:45 +0800
Message-ID: <CAByoP04pSvxrb_ubNXjaneHvBMPVrMyMj5QgmBSfXsCa4D=5AA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.com>, shli@kernel.org, owner-linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,


Recently we find a bug about skip_copy feature in raid5 degraded mode.
In the beginning, we enable the skip_copy feature to speed up system=E2=80=
=99s
write performance. But when the system has database read/write I/O
continually in raid5 degraded mode, the Mongo DB will detect the
checksum error and generate related debug log. The following is the
testing detail.


a. Enable skip_copy
    --> Checksum error logs from Mongo DB

2017-02-06T11:54:56.537+0800 E STORAGE  [conn7] WiredTiger (0)
[1486353296:537114][52:0x7f98396a4700],
file:collection-110-3235234017846331078.wt,  WT_CURSOR.next: read
checksum error for 4096B block at offset 61440: calculated block
checksum of 1363526237 doesn't match expected checksum of 2969711960


b. Disable skip_copy
    --> Mongo DB has no checksum error.


We've pretty sure that it must be a bug by our repeated database I/O
testing. When skip_copy feature is enabled, the raid5/raid6 always
causes the mongo DB checksum error in degraded mode less than one
hour. On the contrary, it will never cause this abnormal situation
when the skip_copy feature is disabled. Besides, because the skip_copy
feature only affects the write action instead of read action, I think
it should be the write action in degraded mode while skip_copy feature
is enabled cause this bug.


Please kindly provide us some help or idea about the root cause and solutio=
n.


Thanks,


--=20

Chien Lee
