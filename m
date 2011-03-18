From: Roberto Spadim <roberto@spadim.com.br>
Subject: i made sh*t can anyone help!?
Date: Fri, 18 Mar 2011 10:43:33 -0300
Message-ID: <AANLkTinGkgSrfqTjYUKGXeR9yfuGws=o8bVhVnuDFMWx@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

hi guys i had a raid1 array, and i made shit, could i undo it? it have
filesystem with files :(

# mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb missing
mdadm: /dev/sdb appears to be part of a raid array:
    level=raid1 devices=2 ctime=Wed Mar 16 19:01:50 2011
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
Continue creating array?
Continue creating array? (y/n) y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
