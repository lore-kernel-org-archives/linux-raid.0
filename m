From: AndyLiebman@aol.com
Subject: SMP and 3ware cards and 2.6 kernel
Date: Sun, 30 May 2004 10:16:47 EDT
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <dc.bd52705.2deb46cf@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi. I'm having a troublesome problem using two different 3ware SATA cards -- 
the 8506 and the 9500 -- under the 2.6 kernel. 

I'm running Mandrake 10 Official with various Mandrake kenels -- 2.6.3-7, 
2.6.6-0-rc3, going to try 2.6.7-0rc1 tommorow and maybe compile my own 2.6.6 
kernel. 

I have a Supermicro X5DPE-G2 motherboard, a single Xeon 3.06 Ghz processor, 2 
GB RAM. I have eight 250 GB Maxtor SATA drives assembled into one 2 TB 
Hardware RAID-5 array. 

So far, when I enable hyperthreading and boot up with any smp kernel, I find 
my system freezes during Bonnie++ tests of the hardware RAID-5. Bonnie++ might 
run for 4 or 5 minutes, and then all of a sudden everything is frozen. There 
are NO messages in any of the Kernel logs at the time of the freeze up. I get 
the same kind of freezing when I'm reading/writing to the RAID array under the 
smp kernel, but usually I can run for up to a couple of hours before disaster 
strikes. 

The curious thing is, I don't get this freezing if I configure my SATA drives 
as JBOD (in the case of the 8506 card) or "single drives" (in the case of the 
9500 card) and make a Software RAID-5 array. The smp kernel doesn't seem to 
cause any problems. 

Does anybody have a clue what could be going on here? Under the 2.4 kernel, 
3ware has distinct procedures for compiling 9500 drivers for smp and 
uniprocessor (or, at least you had to compile the drivers with 'make -f smp Makefile' 
versus 'make -f Makefile'). 

But 3ware's 2.6 driver source doesn't seem to include any special 
instructions for compiling the 9500 driver for use with smp or uniprocessor kernels. 

Again, it's strange that Software RAID isn't giving the cards any trouble 
under a 2.6 smp kernel, but Hardware RAID is causing trouble (at least for me). 

Any ideas? 
