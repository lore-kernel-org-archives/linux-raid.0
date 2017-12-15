From: guomingyang <guomingyang@bwstor.com.cn>
Subject: Is there any lazy initialization mechanism in linux-raid?
Date: Fri, 15 Dec 2017 19:50:45 +0800
Message-ID: <46a50eb1-7836-9ec5-109a-59d223708547@bwstor.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all:

       Today's disk is becoming larger and larger, and the recovery time 
is becoming longer. I'm thinking about a lazy initialization mechanism 
in linux raid5 to speed up recovery, which contains an un-initializing 
bitmap and a backend thread for initializing stripes lazily only after a 
stripe is write. The major difference is as follows:

       (1)When a raid4 or raid5 device is created, we don't recovery a 
disk as usual, instead we just set all the bit in un-initialize bitmap.

       (2)When a write happens and the corresponding un-initializing bit 
is set, we must first clean the bit, then wake up the backend thread to 
resync the stripe, and only do RCW in corresponding stripe before the 
resync is done.

      The major advantage of this mechanism is that when a disk is 
replaced, we can only recovery the stripes which have been initialized, 
so as to speed up recovery.

      Does linux-raid have similar mechanism today? Or is there anyone 
who has already working on similar mechanism?


-- 
Mingyang Guo

