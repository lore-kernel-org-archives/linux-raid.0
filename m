From: Alex <mysqlstudent@gmail.com>
Subject: Re: Help with degraded array
Date: Sat, 14 Dec 2013 12:40:01 -0500
Message-ID: <CAB1R3siFu3q98bT23Lz1u2uVqkxvth35pguzSdBQ7auZkJwumg@mail.gmail.com>
References: <CAB1R3shBH5sAq6qDL4aQcxERA3mMo5UBJGTvVS20JjyW0ZyZLA@mail.gmail.com>
	<52AC351E.5050709@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52AC351E.5050709@suddenlinkmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David C. Rankin" <drankinatty@suddenlinkmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

> It simply looks like the drive designation changed /dev/sda -> /dev/sdc and
> mdadm kicked sda out of the array because it wasn't there. Are you not using
> UUID designation to assemble the arrays? What does your /etc/mdadm.conf look like?
>
> It looks like you could add /dev/sdc3 back into the array, let it rebuild if
> necessary, then use:
>
>  mdadm --detail --scan >> /etc/mdadm.conf
>
> To create a new UUID based mdadm.conf that would prevent this from happening again.

# cat /etc/mdadm.conf

# mdadm.conf written out by anaconda
MAILADDR root
AUTO +imsm +1.x -all
ARRAY /dev/md0 level=raid1 num-devices=2
UUID=99acf2a0:afa1266c:b870423d:f06e4009

So I would then use "mdadm --add /dev/md0 /dev/sdc3" to add it,
correct? It's not necessary to first fail the device?

Thanks again,
Alex
