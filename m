From: "Richard Grundy" <richguk@gmail.com>
Subject: Moving RAID distro
Date: Wed, 15 Aug 2007 17:06:48 +0100
Message-ID: <622273920708150906t196689c8l48836b170986a713@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I was just wonder if it's possible to move my RAID5 array to another
distro, same machine just a different flavor of Linux.

Would it just be a case of running:

sudo mdadm --create --verbose /dev/md0 --level=3D5 =96raid-devices=3D5
/dev/sdb /dev/sdc etc

Or do I need to run some other command.

Thanks,

Rich
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
