From: Johnny Ljunggren <johnny@navtek.no>
Subject: Re: failed to RUN_ARRAY, input/output error
Date: Thu, 20 Apr 2006 12:41:40 +0200
Message-ID: <44476564.9030608@navtek.no>
References: <54490.84.236.149.243.1144790548.squirrel@www.navtek.no> <17468.47969.652243.826774@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17468.47969.652243.826774@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> Add a '--force' to the '--assemble' and it will start the array for
> you.
>   

Just an update (happy one) to the problem. This is what I did (from memory):
-Replaced the failed harddrive
-Used FC5 disc 1 to start in rescue mode
-Used fdisk to partition the new hard drive
-# mdadm -A /dev/md0 /dev/hda2 /dev/hdc2 /dev/hdg1
-# mdadm /dev/md0 -a /dev/hde1
-# mdadm -S /dev/md0
-# mdadm -A --force /dev/md0 /dev/hda2 /dev/hdc2 /dev/hde1 /dev/hdg1
I did some tests with 'mdadm -A --force /dev/md0 /dev/hda2 /dev/hdc2 
/dev/hde1 /dev/hdg1 --update=summaries/resync'  as well but I'm not sure 
if that had anything to do with it.
Anyway, I'm up and running.

-- 
Johnny Ljunggren, Navtek AS
Tlf: 918 50 411, 33 07 10 77

