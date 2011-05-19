From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Best way to create RAID-6 for swap partition - existing one failed
Date: Wed, 18 May 2011 21:26:27 -0500
Message-ID: <4DD47FD3.2000909@hardwarefreak.com>
References: <519370.21161.qm@web65110.mail.ac2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <519370.21161.qm@web65110.mail.ac2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gavin Flower <gavinflower@yahoo.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de, mb@gem.win.co.nz
List-Id: linux-raid.ids

On 5/18/2011 7:11 PM, Gavin Flower wrote:

We're getting pretty OT here...

> What obvious thing have I done, or not done, here?
> 
> What should I do now?
> 
> (I am not panicking, because I can always revert back...)
> 
> I tried to implement you suggestion, 
> 
> # swapoff -a
> # dd if=/dev/zero of=/swapfile1 bs=1K count=16M
> 16777216+0 records in
> 16777216+0 records out
> 17179869184 bytes (17 GB) copied, 119.642 s, 144 MB/s
> # mkswap /swapfile1
> Setting up swapspace version 1, size = 16777212 KiB
> no label, UUID=9afbf206-9a79-45b8-ad4b-148f71c440d7

17GB is a bit ridiculous for swap, especially on a single user machine.

> # swapon /swapfile1
> # cp /etc/fstab /etc/fstab-20110519
> 
> in
> /etc/fstab
> I replaced
> UUID=654f3b90-ed2c-4de6-9f2a-e2ad65fd1af1 swap                    swap    defaults        0 0
> by
> /swapfile1                                swap                    swap    defaults        0 0
> 
> The log message for the swapon was:
> May 19 11:27:38 saturn kernel: [38075.451398] Adding 16777212k swap on /swapfile1.  Priority:-1 extents:159 across:24068092k 

Looks good.

> However, it failed to hibernate.  The log messages were:
> May 19 11:44:43 saturn kernel: [39043.115385] sd 1:0:0:0: [sdb] Starting disk
> May 19 11:44:43 saturn kernel: [39043.128453] sd 2:0:0:0: [sdc] Starting disk
> May 19 11:44:43 saturn kernel: [39043.140116] sd 3:0:0:0: [sdd] Starting disk
> May 19 11:44:43 saturn kernel: [39043.150889] sd 5:0:0:0: [sde] Starting disk
> May 19 11:44:43 saturn kernel: [39043.165729] PM: thaw of devices complete after 756.642 msecs
> May 19 11:44:43 saturn kernel: [39043.322491] PM: Saving image data pages (809839 pages) ... done
> May 19 11:44:43 saturn kernel: [39094.461575] PM: Wrote 3239356 kbytes in 51.13 seconds (63.35 MB/s)
> May 19 11:44:43 saturn kernel: [39094.465739] PM: S
> May 19 11:44:43 saturn kernel: [39094.482407] PM: Swap header not found!
> May 19 11:44:43 saturn kernel: [39094.485188] |
> May 19 11:44:43 saturn kernel: [39094.706731] Restarting tasks ... done.
> May 19 11:44:43 saturn NetworkManager[1501]: <info> wake requested (sleeping: yes  enabled: yes)
> May 19 11:44:43 saturn NetworkManager[1501]: <info> waking up and re-enabling...
> May 19 11:44:43 saturn NetworkManager[1501]: <info> (eth0): now managed

I've never used hibernation, but a quick Google search gives lots of
information on this.  Google "linux swap file hibernate".  I read one
thread from 2008, in which folks easily solved this with a kernel update
or switching the filesystem where they stored the swap file.  I would
think 3 years later any bugs in the hibernation code have been squashed
and this should work flawlessly.

What kernel/distro version are you running?  Anything recent should be
able to handle hibernation to a swap file.

-- 
Stan
