From: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>
Subject: Re: Raid array name by mdadm
Date: Wed, 28 Oct 2015 20:56:41 +0100
Message-ID: <CALtW_agEVF9x83WP6GO0mJ9zjggS_7_9TJ5dJEdijmR8wHf49A@mail.gmail.com>
References: <CA+2rt40JQcxv8CTw-+bpXDGFNorgS53B+thrkNeGN6B2JRQmBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+2rt40JQcxv8CTw-+bpXDGFNorgS53B+thrkNeGN6B2JRQmBw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sheng Yang <sheng@yasker.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I tried to create a raid using:
>
> # mdadm --create device-123 --verbose --level=mirror --raid-devices=2
> --name=device-123 /dev/sda /dev/sdb
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md/device-123 started.
>
> But what I got in the end is only /dev/md127. The directory of
> /dev/md/ doesn't exist.


try mdadm --create /dev/md/device-123,

for example:

truncate -s 512M disk0
truncate -s 512M disk1

losetup /dev/loop0 disk0
losetup /dev/loop1 disk1

mdadm --create /dev/md/device-123 --verbose --level=mirror
--raid-devices=2 /dev/loop0 /dev/loop1

[root@eos ~]# ll /dev/md/device-123
lrwxrwxrwx 1 root root 8 Oct 28 20:53 /dev/md/device-123 -> ../md127

[root@eos ~]# mdadm --detail --scan
ARRAY /dev/md/device-123 metadata=1.2 name=device-123
UUID=03ba5df7:7c5cc933:367e19ef:384665c5
