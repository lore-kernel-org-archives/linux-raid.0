From: Matthias Dahl <ml_linux-raid@binary-island.eu>
Subject: IMSM RAID10: Rebuild/Resync difference on Linux vs Windows
Date: Wed, 22 Feb 2017 14:41:29 +0100
Message-ID: <055fbb58-fb5f-5d69-0974-aaa234c99028@binary-island.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello @everyone,

I had an unclean shutdown today and the RAID was (as expected) out of
sync -- so with the next boot, Linux started a resync.

A while into the resync, I had to fire up Windows due to work, and the
Intel Rapid Storage Manager took over the rebuild as expected. But there
was a crucial difference: When I left Linux, I was at somewhat ~35% with
another 2 hours or so to go for the resync, whereas IRSM was at 97% from
the get-go and took just another 10 minutes or so to (apparently) finish
the job.

On Linux, the resync was taking place at 150 MiB/s to 200 MiB/s. So even
if Windows was syncing faster (as-in: transfer-speed wise), there is no 
way to account for a jump from ~35% to 97%.

That is quite a huge difference and got me worried, since I ran into my 
fair share of bugs with imsm on Linux, unfortunately.

Is this to be expected and normal behavior? Does IRSM on Win use some 
kind of optimization/shortcut during rebuild that is not implemented on 
Linux? Or should this really not be happening and I should indeed be 
worried that the resync was done improperly now?

This happened with kernel 4.9.5 and mdadm/mdmon 4.0 with a RAID10.

If there you need any more information, please don't hesitate to ask and
I will gladly provide it and help figure this out.

Thanks in advance for any help.

So long,
Matthias

-- 
Dipl.-Inf. (FH) Matthias Dahl | Software Engineer | binary-island.eu
  Hire me for contract work: Open Source, Proprietary, Web/Mobile/Desktop
