From: Stephan van Hienen <raid@a2000.nu>
Subject: Re: raid5 slow
Date: Tue, 30 Nov 2004 20:37:10 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0411302034160.24563@adsl.a2000.nu>
References: <200411290449.iAT4nsN02715@www.watkins-home.com>
 <Pine.LNX.4.61.0411290928430.13437@adsl.a2000.nu>
 <Pine.LNX.4.61.0411290948230.13437@adsl.a2000.nu> <16811.48945.141392.294625@cse.unsw.edu.au>
 <Pine.LNX.4.61.0411300146360.32052@adsl.a2000.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0411300146360.32052@adsl.a2000.nu>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Guy <bugzilla@watkins-home.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

today also runned a test with 500gb size :

Version  1.03       ------Sequential Output------ --Sequential Input- 
--Random-
                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- 
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP 
/sec %CP
storage.a2000. 500G 23385  97 79328  69 59189  58 25015  91 122493  58 
67.7  11
                     ------Sequential Create------ --------Random 
Create--------
                     -Create-- --Read--- -Delete-- -Create-- --Read--- 
-Delete--
               files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP 
/sec %CP
                  16  1404  76 +++++ +++ +++++ +++  1347  75 +++++ +++ 
4868  97
storage.a2000.nu,500G,23385,97,79328,69,59189,58,25015,91,122493,58,67.7,11,16,1404,76,+++++,+++,+++++,+++,1347,75,+++++,+++,4868,97

it's really slow... :(
is there anything i can do ?
i want to fill the raid asap

for now i have 2 options :

-use the 2.6 and hope someone is going to fix this ?

-use the 2.4 kernel but max 13 devices (there is no LBD support in 2.4?)
or is there a LBD patch so i can create a 2TB+ raid5 array ?



