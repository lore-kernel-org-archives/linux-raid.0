From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: New setup: partitions or raw devices
Date: Wed, 29 Nov 2017 23:10:14 +0100
Message-ID: <34e548a3-111a-909f-9683-8eae3efafdcc@thelounge.net>
References: <CAJH6TXj4wp-k2QQ0O8W2PDQEg9QHcWwPkOEOSzMgvtbV6b21Cw@mail.gmail.com>
 <7f6abcbc-7dfa-0252-e9df-984e7e637936@thelounge.net>
 <CAJH6TXjbAFjP66HN54kiUffd=zt0HUgyQmcvsU-mYpJRUaQafw@mail.gmail.com>
 <e62ea493-3fae-5c3e-5578-f426dc3d254e@thelounge.net>
 <CAJH6TXgtn7Gqryvs1HKfFCodEqXCaHvy+kXX8kRxWgS25ZUDYQ@mail.gmail.com>
 <3654cb70-9d7c-dfc0-f57d-c57004f11f92@thelounge.net>
 <CAJH6TXhVb2EFJm6jWUcW_6cLfegna-ft7rvm++EECSY2aRTP1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJH6TXhVb2EFJm6jWUcW_6cLfegna-ft7rvm++EECSY2aRTP1A@mail.gmail.com>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



Am 29.11.2017 um 23:02 schrieb Gandalf Corvotempesta:
> 2017-11-29 21:02 GMT+01:00 Reindl Harald <h.reindl@thelounge.net>:
>> in case of 2 TB disks it's 40 GB per disk
> 
> Yes
> 
>> because 100 MB IMHO don't help that much for SSD overprovisioning and given
>> how it may extend the lifetime versus the price and you don't have your
>> disks typically filled completly
> 
> I'm talking about multi-tera disks, I don't think i'll ever (in the
> near future) replace them
> with SSDs....

i thought the same in 2011 and now i regret it *because* i change the 2 
TB disks against SSD's (while i would sell my sould for RAID10 
supporting the RAID1 writemoostly feature to only have writes on the 
current 2 remaining HDD and reads de-facto from the SSD stripe-part)

[harry@srv-rhsoft:~]$ df
Dateisystem    Typ  Größe Benutzt Verf. Verw% Eingehängt auf
/dev/md1       ext4   29G    6,8G   22G   24% /
/dev/md0       ext4  485M     35M  446M    8% /boot
/dev/md2       ext4  3,6T    1,9T  1,8T   53% /mnt/data

[0:0:0:0]    disk    ATA      Samsung SSD 850  2B6Q  /dev/sda
[1:0:0:0]    disk    ATA      Samsung SSD 850  2B6Q  /dev/sdb
[2:0:0:0]    disk    ATA      WDC WD2003FYYS-0 1D01  /dev/sdc
[3:0:0:0]    disk    ATA      ST2000DX002-2DV1 CC41  /dev/sdd
