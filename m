From: Sheng Yang <sheng@yasker.org>
Subject: Raid array name by mdadm
Date: Wed, 28 Oct 2015 11:43:46 -0700
Message-ID: <CA+2rt40JQcxv8CTw-+bpXDGFNorgS53B+thrkNeGN6B2JRQmBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi guys,

I am trying to find a way to make mdadm create /dev/md/<devicename>
instead of /dev/mdnn only. I found it seems possible from the manual
of mdadm(http://linux.die.net/man/8/mdadm). It said:

If the md device name is in a 'standard' format as described in DEVICE
NAMES, then it will be created, if necessary, with the appropriate
device number based on that name. If the device name is not in one of
these formats, then a unused device number will be allocated. The
device number will be considered unused if there is no active array
for that number, and there is no entry in /dev for that number and
with a non-standard name. Names that are not in 'standard' format are
only allowed in "/dev/md/".

I tried to create a raid using:

# mdadm --create device-123 --verbose --level=mirror --raid-devices=2
--name=device-123 /dev/sda /dev/sdb
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md/device-123 started.

But what I got in the end is only /dev/md127. The directory of
/dev/md/ doesn't exist.

Though the detail showed the correct name

# mdadm --detail --scan
ARRAY /dev/md127 metadata=1.2 name=98abb2346b83:device-123
UUID=6a31df29:adec4bff:e8867610:c0e10723

It's much more convenient if I could use the name of
/dev/md/device-123 instead of /dev/md127. I've tried google for hours
without success.

# mdadm --version
mdadm - v3.3 - 3rd September 2013

If anyone can shed some light on it, I would be appreciate!

Thanks!

--Sheng
