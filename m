From: Alex Verbitsky <alexver5@mail.ru>
Subject: 3ware 7500 performance, was: experiences with 3Ware 6400 3W-6400?
Date: Sat, 28 Jun 2003 17:00:15 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <6661311060.20030628170015@mail.ru>
References: <Pine.LNX.4.33.0306271017580.9087-100000@router.windsormachine.com>
Reply-To: Alex Verbitsky <alexver5@mail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.33.0306271017580.9087-100000@router.windsormachine.com>
To: Mike Dresser <mdresser_l@windsormachine.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Mike,

Friday, June 27, 2003, 5:36:09 PM, you wrote:
MD> P4 2.53, Asus P4B533-e, 3ware 7500-4, 4 Maxtor Maxline 250 gb drives in
MD> raid5.
MD> mickey,512M,17840,60,19878,5,8683,2,28247,89,91356,8,243.0,0,16,2576,81,+++++,+++,+++++,+++,3184,96,+++++,+++,9392,96

MD> P4 2.53, Asus P4B533, 3ware 7500-4, 2 Maxtor DiamondMax 9 200 gb drives in
MD> Raid1. (different machine)
MD> r1,512M,26616,94,52362,15,21394,5,28918,92,47633,4,301.8,0,16,3145,99,+++++,+++,+++++,+++,3214,99,+++++,+++,10229,95

MD> Half to a third the write speed, although the read speed is a lot
MD> better.
What kernel did you use for testing?
I believe it makes difference: when i tried RH9 (2.4.20 kernel) i got
for 3 drive harware RAID5 - 11 MB/s seq write,
after downgrading to RH8 (2.4.18-14) i got 25-26 MB/s.
drives were ibm AVVA 80GB 7200RPM

when i added another 3 drives (ibm dtla, maxtor and barracuda 4 -
all 7200rpm) i got on 6 drive RAID5 - 29.5 MB/s (though CPU usage was
high - 50%)

upgrading to 2.4.21 made no difference (against 2.4.18),
upgrading firmware to 7.6 - the same.

my configuraton: Via Epia-M with Via C3-933mhz CPU, 256MB RAM, 3ware 7500-8

under Win2k on the same configuration i got 40-42 MB/s seq write for
4 drive harware RAID5 with 6% CPU usage.

As a conclusion, seems that RH9's kernel (and maybe some other kernels?) are broken.

Also, did you tweaked max-readahead/min-readahead params?
doing this:
        echo 256 > /proc/sys/vm/max-readahead
        echo 128 > /proc/sys/vm/min-readahead
increased my sequental read from 58 MB/s to 80 MB/s (at expense of CPU
usage - from 22% to 36%).

Also you did not report your RAM size. if you have 512 MB, your
results are not very accurate because some amount of writes is
cached.
I believe that test file should be at least twice size of the system
RAM, 4-6 times are better.

MD> Haven't upgraded to the 7.6 firmware yet(still using 7.5.3 that was on
MD> the card), anyone notice any difference?
I highly recommend you to upgrade - though i did not notice any
performance gains, it contains new improved CLI utility with online
array create/delete commands, and also better support RH8.

MD> The 7000-2 and 7500-4's in raid1 work quite nicely.  The 7500-4 in raid5
MD> actually lags the system for 3-5 seconds when doing a lot of disk i/o.
MD> Feels like working on a p120 with DMA shut off, to be honest.
What do you mean by this? I did not notice anything like this, though i
use it for sequental i/o mainly.
if your i/o is highly random, then 3ware acceleration (R5 fusion) is
not working and you should receive something like 5-10 MB/s.


-- 
Best regards,
 Alex                            mailto:alexver5@mail.ru

