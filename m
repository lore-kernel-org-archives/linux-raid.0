From: "Biro Andras" <Andras.Biro@humansoft.hu>
Subject: Raid 5 Performace
Date: Thu, 8 Jan 2004 11:23:31 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <65113A5C2C79DB42B5FBEFFD3159AA490E067F@w2ksrv01.hsdomain.humansoft.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello

Because I did not find any recent performance charts I've made a short test with bonnie.
maybe useful
result:
Version  1.03       ------Sequential Output------ --Sequential Input- --Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
ser-pe2650       2G           106521  93 65022  49           231492  85  1122   4
                    ------Sequential Create------ --------Random Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
                 16 16740  83 +++++ +++ 17308 100 19311  99 +++++ +++ 16090 100
ser-pe2650,2G,,,106521,93,65022,49,,,231492,85,1121.9,4,16,16740,83,+++++,+++,17308,100,19311,99,+++++,+++,16090,100

Dell Poweredge 2650 2*2Ghz xeon; 1Gb RAM, 
md device: 14*36Gb 10KRPM SCSI HDD on two channels of an adaptec 39160 (2*7 disk)
md0 : active raid5 sdq1[13] sdp1[12] sdo1[11] sdn1[10] sdm1[9] sdl1[8] sdk1[7] sdj1[6] sdi1[5] sdh1[4] sdg1[3] sdf1[2] sde1[1] sdd1[0]
      462275840 blocks level 5, 256k chunk, algorithm 2 [14/14] [UUUUUUUUUUUUUU]

I think the bottleneck is the 39160 because it runs only on 64bit 33 MHz

regards

Smalla


