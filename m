From: Srinivasa S <srinivasa.s@gmail.com>
Subject: help
Date: Wed, 20 Oct 2004 10:35:46 +0530
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <8f8a5194041019220528e9d45@mail.gmail.com>
Reply-To: Srinivasa S <srinivasa.s@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i've a raid 5 setup with 3 disks each of 1 GB. i'm using it for some
experimentation purpose. resync is n progress and is not ending at
all. its almost 15 hrs since the resync started and the "cat
/proc/mdstat" always shows something like this.

Personalities : [raid5] 
md0 : active raid5 sdj1[2] sdi1[1] sdh1[0]
      2002688 blocks level 5, 8k chunk, algorithm 2 [3/3] [UUU]
      [>....................]  resync =  0.0% (0/1001344)
finish=442287.5min speed=0K/sec

is there anything wrong - can i possibly stop the resync. the problem
i'm having is that whichever process tries to do IO with the array is
hanging. please help. thanks.

srinivasa s
