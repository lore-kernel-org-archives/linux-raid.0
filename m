From: Alex <mysqlstudent@gmail.com>
Subject: Re: Help with degraded array
Date: Sat, 14 Dec 2013 19:34:38 -0500
Message-ID: <CAB1R3sgU5eOh_MTtY=7ZwWwbvQV6py2dzNFku0PKzjB4-oEuRg@mail.gmail.com>
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

>   What I would do is run smartctl -t short /dev/sdc, then smartctl -a /dev/sdc
> and make sure the drive was reported as PASSED and not in imminent failure. Then
> run fsck on /dev/sdc2 (the partition reporting the I/O error on what was sda2 --
> DO NOT fsck /dev/sdc3.

I ran a short (which succeeded) then a long (which also succeeded)
test on /dev/sdc.

I realized that /dev/sdc2 is a non-raid partition mounted as /boot, so
it can't be checked.

This box is in a remote datacenter. Still think it's okay to boot remotely?

Thanks,
Alex
