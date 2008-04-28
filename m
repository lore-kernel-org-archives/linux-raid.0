From: "kyle" <kylewong@southa.com>
Subject: Re: ahci slow transfer rate with kernel 2.6.23-2.6.25
Date: Mon, 28 Apr 2008 22:45:20 +0800
Message-ID: <003901c8a93e$7b4e88b0$0a01a8c0@kylecea1512a3f>
References: <9359bbd70804280211ta587f87sff83dba5f7974796@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="UTF-8";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: "Sergey A. Sukiyazov" <sergey.sukiyazov@gmail.com>, kyle <kylewong@southa.com>
List-Id: linux-raid.ids

Ok, I'll try set queue_depth to 1 to see if there's any improvement. btw, 
the same disk connected to sil3132 controller has no problem at all with 
queue_depth = 31, I got over 100MB/s for hdparm, dd, etc test with 
ST3500320AS + sil3132. So I assume the problem would be ahci.

Thanks a lot.

----- Original Message ----- 
From: Sergey A. Sukiyazov
To: kylewong@southa.com
Sent: Monday, April 28, 2008 5:11 PM
Subject: Re: ahci slow transfer rate with kernel 2.6.23-2.6.25


Hi

I have some problem. Try set queue_depth in "1" for disks, it disables NCQ 
and the transfer rate
has returned to 100MB/S. It's ST3500320AS problem with NCQ implementation (I 
think :-))

for i in sda sdb sdd sdf ; do
    echo "1" > /sys/block/${i}/device/queue_depth
done


See also: http://bugzilla.kernel.org/show_bug.cgi?id=8327

-- 
Best regards
Sergey A. Sukiyazov
http://corwin.rostovlinux.ru/ 

