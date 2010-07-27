From: Marco <jjletho67-diar@yahoo.it>
Subject: Re: raid1 performance
Date: Tue, 27 Jul 2010 09:10:54 -0700 (PDT)
Message-ID: <28427.21084.qm@web28510.mail.ukl.yahoo.com>
References: <443220.14357.qm@web28508.mail.ukl.yahoo.com> <20100725211926.7547c12e@natsu> <23123.42111.qm@web28503.mail.ukl.yahoo.com> <20100726102406.GA8415@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100726102406.GA8415@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Keld Simonsen <keld@keldix.com>
Cc: Roman Mamedov <roman@rm.pp.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> 
>> 
>> >> doing a simple performance tests i obtained some very unexpected results: 
>if
>> >> i issue hdparm -t /dev/md2 i obtain 61 - 65 MB/s while issuing the same test 
>>
>> >> directly on the partitions which compose md2 (/dev/sda3 and /dev/sdb3) i
>> >> obtain 84 - 87 MB/s. I didn't expect a so big difference between md2 and 
>one
>> >> of its member. What can cause  this difference ? 
>> >
>> >Maybe their read-ahead settings are different?
>> >Check out "blockdev --getra /dev/md2", and compare that with the same
>> >setting of the member disks. You can experiment with changing it by using
>> >"--setra" as well.
>> 
>> Hi Roman,
>> thank you for your hint, I verified the read-ahead settings and they are the 
>> same for all the block devices involved in the test: the value is 256 for all 

>> /dev/sd?? and for all /dev/md?
>> there should be something else which is influencing  raid 1 performance.
>> Have someone of you ever had a similar issue ?
>
>Did you try:
>
># Set read-ahead.
>echo "Setting read-ahead to 64 MiB for /dev/md3"
>blockdev --setra 65536 /dev/md3
>
Hi,
i did some test modifying the readahead value with this results:

1) setting the ra value to 65536 only to the /dev/md2 has no effect on 
performance 

2) setting the ra value to 65536 to both /dev/md2 and on his member (/dev/sda3 
and /dev/sdb3) has REDUCED the performance of the single member (hdparm -t 
/dev/sd?3 produce value betwen 65 and 75 Mb/s) and has no effect on /dev/md2 (60 
-65 MB/s)

Onestly i'm confused...an increased read ahead value should normally increase 
performance on sequetial read, shouldn't it? 


Marco


      
