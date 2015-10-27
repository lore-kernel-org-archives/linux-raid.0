From: Phil Turmel <philip@turmel.org>
Subject: Re: [UU_] Won't go away
Date: Tue, 27 Oct 2015 08:23:26 -0400
Message-ID: <562F6CBE.5020504@turmel.org>
References: <562F6B56.9040901@highpoweredhelp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <562F6B56.9040901@highpoweredhelp.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Munger <michael@highpoweredhelp.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/27/2015 08:17 AM, Michael Munger wrote:
> It's my understanding, that an array running with [UU_] is degraded and
> there is a disk problem.
> 
> I have been trying to create a RAID array using this command:
> 
> mdadm --create --verbose /dev/md0 --level=5 --raid-devices=3 /dev/sdb1
> /dev/sdc1 /dev/sdd1
> 
> However, once it create it, it get this in /proc/mdstat:
> 
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 sdd1[3] sdc1[1] sdb1[0]
>       3906764800 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2]
> [UU_]
>       [>....................]  recovery =  0.1% (2611780/1953382400)
> finish=1737.7min speed=18709K/sec
>       bitmap: 0/15 pages [0KB], 65536KB chunk

What's to fix?  Did you try waiting for the recovery to finish?
Creating an array generally isn't instant -- the redundancy has to be
computed over the entire array.

Now, you might have speed limits that are making it slower than possible
(see man md), but multiple hours on big devices is perfectly normal.

Phil
