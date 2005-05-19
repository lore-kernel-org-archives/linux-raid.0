From: Jay Strauss <me@heyjay.com>
Subject: Re: Raid 1 install revealed poor HD performance (I think)
Date: Thu, 19 May 2005 10:32:43 -0500
Message-ID: <428CB19B.8010402@heyjay.com>
References: <428A09A3.9000802@heyjay.com> <428A81FB.1070201@home.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <428A81FB.1070201@home.se>
Sender: linux-raid-owner@vger.kernel.org
To: Henrik Holst <henrik_holst@home.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi (again):

I diff'ed the contents of /proc/ide of Knoppix and Sarge, there were a 
couple of (possibly) interesting differences.  I'm not sure how to go 
about changing the settings.  The net/net is on my controller under 
knoppix it says UDMA Enabled but on Sarge it's disabled.  Also the 
writecache is enabled under knoppix (I did a hdparm -W 1 /dev/hda, but 
my tests were identical)

Below are the diffs,  I'd like to make the sarge install setting 
identical, and see if that changes anything.

If anyone knows how to alter these settings, I'd be appreciated

thanks
Jay

jstrauss@hydrogen:~$ diff -r sarge.ide/sis knoppix.ide/sis
10,11c10,11
<                 UDMA Enabled                   UDMA Enabled
<                 UDMA Cycle Time    2 CLK       UDMA Cycle Time    4 CLK
---
 >                 UDMA Disabled                          UDMA Disabled
 >                 UDMA Cycle Time    Reserved    UDMA Cycle Time 
Reserved

and
jstrauss@hydrogen:~$ diff sarge.ide/hda/settings knoppix.ide/hda/settings
7a8
 > breada_readahead        8               0               255 
    rw
9c10
< current_speed           68              0               70              rw
---
 > current_speed           12              0               70 
    rw
11c12,13
< init_speed              68              0               70              rw
---
 > file_readahead          124             0               16384 
    rw
 > init_speed              12              0               70 
    rw
16c18,19
< multcount               0               0               16              rw
---
 > max_kb_per_request      128             1               255 
    rw
 > multcount               16              0               16 
    rw
20a24
 > slow                    0               0               1 
    rw
23c27
< wcache                  1               0               1               rw
---
 > wcache                  0               0               1 
    rw
