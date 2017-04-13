From: Scott Ellentuch <tuctboh@gmail.com>
Subject: (unknown)
Date: Thu, 13 Apr 2017 11:58:37 -0400
Message-ID: <CAM-0sLzUKM6jbda-j6d+kkY7Vfs7gGtU7wNr11tjFtVCDdU2YQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Subject: 
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

for disk in a b c d g h i j k l m n
do

  disklist="${disklist} /dev/sd${disk}1"

done

mdadm --create --verbose /dev/md2 --level=5 --raid=devices=12  ${disklist}

But its telling me :

mdadm: invalid number of raid devices: devices=12


I can't find any definition of a limit anywhere.

Thank you, Tuc
