From: Jyri Hovila <jyri.hovila@dataprey.fi>
Subject: Starting point of the actual RAID data area
Date: Sat, 7 Oct 2006 20:34:24 +0300
Message-ID: <2341BC7C-A023-4E59-8D2E-773EC9AF031E@dataprey.fi>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello, world!

I'm experimenting with Linux software RAID recovery. My target is to  
be able to recover RAID 5 from individual drives without using the  
Linux RAID tools - I mean mdadm and the others. I know it's not the  
easiest way, but I *do* need to figure out a way to recover Linux  
RAID using Windows... Sorry... ;)

What I'd like to know is how can I find where the actual RAID data  
area starts on disks participating in a RAID 5 set. I know most of  
the RAID configuration information is stored on all of the drives,  
but I'm not geek enough to learn how it's stored from the RAID source  
code.

I would appreciate it a lot if somebody could give me a hand here.  
All I need to understand right now is how I can find out the first  
sector of the actual RAID data. I'm starting with a simple  
configuration, where there are three identical drives, all of them  
used fully for one RAID 5 set. And no LVM at this point.

All comments and ideas are warmly welcome.

Thanks in advance!

Yours,

Jyri

______________________________
DataPrey
Director of Technology
http://www.DataPrey.com
jyri.hovila@dataprey.com
+358 (0)20 747 9872

Customer service 24/7
+358 (0)20 747 9870


