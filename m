From: "Maik Purwin" <maik@purwin-it.de>
Subject: (unknown)
Date: Mon, 17 Dec 2012 01:59:17 +0100
Message-ID: <a242a8e5475e737e42902d043d9cf4d0.squirrel@admin.purwin-it.de>
Reply-To: maik@purwin-it.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Subject: 
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,
i make a misstake and disconnected 2 of my 6 disk in a software raid 5 on
debian squeeze. After that the two disks reported as missing and spare so
i have 4 on 4 in raid5.

after that i tried to add and re-add but without no efforts. Then i do this:

mdadm --assemble /dev/md2 --scan --force
mdadm: failed to add /dev/sdd4 to /dev/md2: Device or resource busy
mdadm: /dev/md2 assembled from 4 drives and 1 spare - not enough to start
the array.

and now i didnt know to go on. i have fear to setup the raid new. I hope
you can help.

Many thx.

