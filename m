From: Simon Jackson <sjackson@bluearc.com>
Subject: Write intent bitmaps.
Date: Mon, 24 Aug 2009 15:39:01 +0100
Message-ID: <ABFC24E4C13D81489F7F624E14891C860D1F15EF@uk-ex-mbx1.terastack.bluearc.com>
References: <5c45fce80908230116o2f129ab4y8d255cbe83bfac5b@mail.gmail.com>
 <87ws4t4bjz.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87ws4t4bjz.fsf@frosties.localdomain>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



I am trying to use write intent bitmaps on some RAID 1 volumes to reduce the rebuild times in the event of hard resets that cause the md driver to kick members out of my arrays.

I used the mdadm --grow /dev/md0 --bitmap=internal  and this appeared to succeed, but when I tried to examine the bitmap I get an error. 


:~$ sudo mdadm --grow /dev/md0 --bitmap=internal
:~$ sudo mdadm -X /dev/md0
        Filename : /dev/md0
           Magic : 00000000
mdadm: invalid bitmap magic 0x0, the bitmap file appears to be corrupted
         Version : 0
mdadm: unknown bitmap version 0, either the bitmap file is corrupted or you need to upgrade your tools

cat /proc/mdstat
Personalities : [raid1] 
      
md0 : active raid1 sda5[0] sdb5[1]
      7823552 blocks [2/2] [UU]
      bitmap: 29/239 pages [116KB], 16KB chunk
      
unused devices: <none>
sjackson@mercuryst5:~$ sudo mdadm -X /dev/md0
        Filename : /dev/md0
           Magic : 00000000
mdadm: invalid bitmap magic 0x0, the bitmap file appears to be corrupted
         Version : 0
mdadm: unknown bitmap version 0, either the bitmap file is corrupted or you need to upgrade your tools

Do I really have a usable bitmap on the device in this case?

Thanks for any input.  


