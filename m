From: "Adam J Morand" <Adam.Morand@midnightmoon.ca>
Subject: Re: RAID 1 / Power Loss / No SuperBlock
Date: Sun, 2 Feb 2003 13:27:27 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <016501c2cb01$e7811f00$6701a8c0@bc.hsia.telus.net>
References: <Pine.LNX.4.33.0302021631280.17543-100000@router.windsormachine.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Mike Dresser <mdresser_l@windsormachine.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

right now it is all gibbled, I do not have a copy of the proc when it was
working, but says this

cat /proc/mdstat
Personalities : [raid0] [raid1]
read_ahead 1024 sectors
md0 : active raid0 hda3[1] hdb3[0]
      26619520 blocks 64k chunks

md2 : active raid1 hdb1[0]
      5116544 blocks [2/1] [_U]

md1 : active raid1 hda2[1]
      20482752 blocks [2/1] [U_]

unused devices: <none>




----- Original Message -----
From: "Mike Dresser" <mdresser_l@windsormachine.com>
To: "Adam J Morand" <Adam.Morand@midnightmoon.ca>
Cc: <linux-raid@vger.kernel.org>
Sent: Sunday, February 02, 2003 1:32 PM
Subject: Re: RAID 1 / Power Loss / No SuperBlock




On Sun, 2 Feb 2003, Adam J Morand wrote:

> Mike,
>
> errors included:
> cannot determine md version: No such file or directory
> and
> mount: wrong fs type, bad option, bad superblock on /dev/md2,
>        or too many mounted file systems
>

And one last thing, what does /proc/mdstat say?

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

