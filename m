From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: mdadm: RUN_ARRAY failed: Cannot allocate memory
Date: Sat, 24 Mar 2007 12:26:52 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0703241216590.21973@filesrv1.baby-dragons.com>
References: <Pine.LNX.4.64.0703212139010.2224@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0703212139010.2224@filesrv1.baby-dragons.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 	Hello Neil ,  I found the problem that caused the 'cannot allcate 
memory' ,  DON'T use '--bitmap=' .
 	But that said ,  Hmmmm ,  Shouldn't mdadm just stop & say ...
 	'md: bitmaps not supported for this level.'
 	Like it puts out into  dmesg .

 	Also think this message in dmesg is interesting .
 	"raid0: bad disk number -1 - aborting!'

 		Hth ,  JimL

ps:

# mdadm -C /dev/md6 -l 0 -n 3 --bitmap=internal /dev/md[3-5]
mdadm: /dev/md4 appears to be part of a raid array:
     level=raid0 devices=3 ctime=Sat Mar 24 18:13:38 2007
mdadm: /dev/md5 appears to be part of a raid array:
     level=raid0 devices=3 ctime=Sat Mar 24 18:13:38 2007
Continue creating array? y
mdadm: RUN_ARRAY failed: Cannot allocate memory
mdadm: stopped /dev/md6


# mdadm --version
mdadm - v2.6.1 - 22nd February 2007

# uname -a
Linux filesrv1b 2.6.21-rc4 #2 SMP Thu Mar 22 04:19:35 UTC 2007 i686 pentium4 i386 GNU/Linux


More info at:
http://www.baby-dragons.com/filesrv2-raid-and-scsi-device-LettersnNumbers.txt

-- 
+-----------------------------------------------------------------+
| James   W.   Laferriere | System   Techniques | Give me VMS     |
| Network        Engineer | 663  Beaumont  Blvd |  Give me Linux  |
| babydr@baby-dragons.com | Pacifica, CA. 94044 |   only  on  AXP |
+-----------------------------------------------------------------+
