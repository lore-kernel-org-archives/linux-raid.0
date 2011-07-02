From: =?UTF-8?B?S2Fyc3RlbiBSw7Zta2U=?= <k.roemke@gmx.de>
Subject: Re: misunderstanding of spare and raid devices? - and one question
 more
Date: Sat, 02 Jul 2011 10:34:30 +0200
Message-ID: <4E0ED816.30903@gmx.de>
References: <4E0C5539.4030000@gmx.de> <4E0C5E47.5090604@anonymous.org.uk> <4E0C6CC4.3030506@turmel.org> <4E0C7196.1070307@gmx.de> <4E0C7B4B.7090404@turmel.org> <4E0C8685.3020806@gmx.de> <4E0C8BD6.1080907@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E0C8BD6.1080907@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Phil,
I have done some tests and appended the results, maybe they are of interest
for somebody. As a conclusion I would say raid5 and raid6 make in my situation
nearly no difference.
Thanks to all for hints and explanation
           Karsten



--------------------------------------------------------------------------------------
first - just copy a dir with a size of 2,9 GB, it was copied once before so I
think there are still data buffered?

OLDER war im Cache? hatte Dir vorher kopiert
kspace9:~ # date ; cp -a /home/roemke/HHertzTex/OLDER/* /raid5/ ; date
Fr 1. Jul 16:15:57 CEST 2011
Fr 1. Jul 16:16:26 CEST 2011

kspace9:~ # date ; cp -a /home/roemke/HHertzTex/OLDER/* /raid6/ ; date
Fr 1. Jul 16:17:27 CEST 2011
Fr 1. Jul 16:17:58 CEST 2011

--------------------------------------------------------------------------------------
now a test with bonnie, I found this  example online and the parameters seems
senseful to me (I've never done performance tests on hd's before, so I searched
for an example)
bonnie, found
-n 0 : file creation  0
-u 0 : root
-r   : memory in megabyte (calculated to 7999)
-s   : file size calculated to 15998
-f   : fast, skip per char IO-tests
-b   : no write buffering
-d   : set directory

kspace9:~ # bonnie++ -n 0 -u 0 -r `free -m | grep 'Mem:' | awk '{print $2}'` -s $(echo "scale=0;`free -m | grep 'Mem:' | awk 
'{print $2}'`*2" | bc -l) -f -b -d /raid5
Using uid:0, gid:0.
Writing intelligently...done
Rewriting...done
Reading intelligently...done
start 'em...done...done...done...
Version 1.03d       ------Sequential Output------ --Sequential Input- --Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
kspace9      15998M           96365  20 48302  12           149445  18 113.7   0
kspace9,15998M,,,96365,20,48302,12,,,149445,18,113.7,0,,,,,,,,,,,,,

kspace9:~ # bonnie++ -n 0 -u 0 -r `free -m | grep 'Mem:' | awk '{print $2}'` -s $(echo "scale=0;`free -m | grep 'Mem:' | awk
'{print $2}'`*2" | bc -l) -f -b -d /raid6
Using uid:0, gid:0.
Writing intelligently...done
Rewriting...done
Reading intelligently...done
start 'em...done...done...done...
Version 1.03d       ------Sequential Output------ --Sequential Input- --Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
kspace9      15998M           100321  22 48617  13           131651  16 120.2   1
kspace9,15998M,,,100321,22,48617,13,,,131651,16,120.2,1,,,,,,,,,,,,,


===================================================================================
results for old raid 1:
a test of old raid 1 which I have done unintended, because I forgot to mount
the raid array :-)
mounten vergessen ---------------------------------------------------------------------
-> vergleichsresultate :-)

kspace9:~ # date ; cp -r /home/roemke/HHertzTex/OLDER/ /raid5/ ; date
Fr 1. Jul 16:07:32 CEST 2011                              ^^^ not raid 5, old raid 1, forgot to mount
Fr 1. Jul 16:08:39 CEST 2011
aehnlich (similiar)


test mit bonnie++
kspace9:~ # bonnie++ -n 0 -u 0 -r `free -m | grep 'Mem:' | awk '{print $2}'` -s $(echo "scale=0;`free -m | grep 'Mem:' | awk 
'{print $2}'`*2" | bc -l) -f -b -d /raid5 <-- not raid 5, still the older raid 1
Using uid:0, gid:0.
Writing intelligently...done
Rewriting...done
Reading intelligently...done
start 'em...done...done...done...
Version 1.03d       ------Sequential Output------ --Sequential Input- --Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
kspace9      15998M           62977   9 34410   9           101979  13  66.7   0
kspace9,15998M,,,62977,9,34410,9,,,101979,13,66.7,0,,,,,,,,,,,,,
