From: Alex <mysqlstudent@gmail.com>
Subject: Re: Help with degraded array
Date: Wed, 18 Dec 2013 11:49:19 -0500
Message-ID: <CAB1R3sh6VU_jqiOZ4K7hQG6hng+q1Cct-8Mi6_gX9NJW+oNs8Q@mail.gmail.com>
References: <CAB1R3shBH5sAq6qDL4aQcxERA3mMo5UBJGTvVS20JjyW0ZyZLA@mail.gmail.com>
	<52AC351E.5050709@suddenlinkmail.com>
	<CAB1R3siFu3q98bT23Lz1u2uVqkxvth35pguzSdBQ7auZkJwumg@mail.gmail.com>
	<52ACA2A0.4060405@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52ACA2A0.4060405@suddenlinkmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David C. Rankin" <drankinatty@suddenlinkmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

> The drive at /dev/sda3 has already been failed/removed. The reason was:
>
> Buffer I/O error on device sda2, logical block 65536
> lost page write due to I/O error on sda2
> JBD2: Error -5 detected when updating journal superblock for sda2-8.
>
>   What I would do is run smartctl -t short /dev/sdc, then smartctl -a /dev/sdc
> and make sure the drive was reported as PASSED and not in imminent failure. Then
> run fsck on /dev/sdc2 (the partition reporting the I/O error on what was sda2 --
> DO NOT fsck /dev/sdc3.

Okay, ran a non-destructive badblocks after the smartctl test and it
passed. Rebooted and it switched back to sda from sdc. Ran "mdadm
--add /dev/md0 /dev/sda3" and it's now rebuilding.

I've done all this before, but somehow got a little nervous with it
being 3000 miles away and at a customer's location :-)

Thanks so much, everyone, for all your help.
Regards,
Alex
