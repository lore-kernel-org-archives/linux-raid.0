From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: recommended way to add ssd cache to mdraid array
Date: Tue, 15 Jan 2013 02:38:18 -0600
Message-ID: <50F5157A.2080308@hardwarefreak.com>
References: <201212212357.19292.thomas@fjellstrom.ca> <201301141453.13819.thomas@fjellstrom.ca> <50F4B5E5.30809@hardwarefreak.com> <201301142052.06390.thomas@fjellstrom.ca>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201301142052.06390.thomas@fjellstrom.ca>
Sender: linux-raid-owner@vger.kernel.org
To: thomas@fjellstrom.ca
Cc: Tommy Apel Hansen <tommyapeldk@gmail.com>, Chris Murphy <lists@colorremedies.com>, linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1/14/2013 9:52 PM, Thomas Fjellstrom wrote:
...
> I haven't been comparing it against my other system, as its kind of apples and 
> oranges. My old array, on somewhat similar hardware for the most part, but 
> uses older 1TB drives in RAID5.
...
> It is working. And I can live with it as is, but it does seem like something 
> isn't right. If thats just me jumping to conclusions, well thats fine then. 
> But 600MB/s+ reads vs 200MB/s writes seems a tad off.

It's not off.  As myself and others stated previously, this low write
performance is typical of RAID6, particularly for unaligned or partial
stripe writes--anything that triggers a RMW cycle.

> I'm running the same iozone test on the old array, see how it goes. But its 
> currently in use, and getting full (84G free out of 5.5TB), so I'm not 
> positive how well it'll do as compared to if it was a fresh array like the new 
> nas array.
...
> Preliminary results show similar read/write patterns (140MB/s write, 380MB/s 
> read), albeit slower probably due to being well aged, in use, and maybe the 
> drive speeds (the 1TB drives are 20-40MB/s slower than the 2TB drives in a 
> straight read test, I can't remember the write differences).

Yes, the way in which the old filesystem has aged, and the difference in
single drive performance, will both cause lower numbers on the old hardware.

What you're really after, what you want to see, is iozone numbers from a
similar system with a 7 drive md/RAID6 array with XFS.  Only that will
finally convince you, one way or the other, that your array is doing
pretty much as well as it can, or not.  However, even once you've
established this, it still doesn't inform you as to how well the new
array will perform with your workloads.

On that note, someone stated you should run iozone using O_DIRECT writes
to get more accurate numbers, or more precisely, to eliminate the Linux
buffer cache from the equation.  Doing this actually makes your testing
LESS valid, because your real world use will likely include all buffered
IO, and no direct IO.

What you should be concentrating on right now is identifying if any of
your workloads make use of fsync.  If they do not, or if the majority do
not (Samba does not by default IIRC, neither does NFS), then you should
be running iozone with fsync disabled.  In other words, since you're not
comparing two similar systems, you should be tweaking iozone to best
mimic your real workloads.  Running iozone with buffer cache and with
fsync disable should produce higher write numbers, which should be
closer to what you will see with your real workloads.

-- 
Stan

