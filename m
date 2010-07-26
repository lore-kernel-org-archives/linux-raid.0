From: Marco <jjletho67-diar@yahoo.it>
Subject: Re: raid1 performance
Date: Mon, 26 Jul 2010 09:37:20 +0000 (GMT)
Message-ID: <23123.42111.qm@web28503.mail.ukl.yahoo.com>
References: <443220.14357.qm@web28508.mail.ukl.yahoo.com> <20100725211926.7547c12e@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100725211926.7547c12e@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <roman@rm.pp.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



>> doing a simple performance tests i obtained some very unexpected results: if
>> i issue hdparm -t /dev/md2 i obtain 61 - 65 MB/s while issuing the same test 
>> directly on the partitions which compose md2 (/dev/sda3 and /dev/sdb3) i
>> obtain 84 - 87 MB/s. I didn't expect a so big difference between md2 and one
>> of its member. What can cause  this difference ? 
>
>Maybe their read-ahead settings are different?
>Check out "blockdev --getra /dev/md2", and compare that with the same
>setting of the member disks. You can experiment with changing it by using
>"--setra" as well.

Hi Roman,
thank you for your hint, I verified the read-ahead settings and they are the 
same for all the block devices involved in the test: the value is 256 for all 
/dev/sd?? and for all /dev/md?
there should be something else which is influencing  raid 1 performance.
Have someone of you ever had a similar issue ?

thank you

Marco



      
