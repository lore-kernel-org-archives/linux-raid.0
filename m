From: Neil Brown <neilb@suse.de>
Subject: Re: Raid5 reshape
Date: Wed, 21 Jun 2006 16:02:39 +1000
Message-ID: <17560.57599.658968.66555@cse.unsw.edu.au>
References: <449250ED.7090302@irule.net>
	<17554.21119.487820.638171@cse.unsw.edu.au>
	<4492D5B1.60004@nigelterry.net>
	<4492D8D9.7010101@irule.net>
	<17555.12441.42212.93049@cse.unsw.edu.au>
	<4493330E.30501@nigelterry.net>
	<17555.13409.834439.80361@cse.unsw.edu.au>
	<44945643.3070300@nigelterry.net>
	<17556.31295.280083.533342@cse.unsw.edu.au>
	<44947BCA.9040305@nigelterry.net>
	<44947C98.6060809@nigelterry.net>
	<17556.32630.611922.294047@cse.unsw.edu.au>
	<44948002.3050706@nigelterry.net>
	<44954DB7.2000305@nigelterry.net>
	<17558.1521.522659.91428@cse.unsw.edu.au>
	<44971A51.6050008@nigelterry.net>
	<17559.10564.840472.525999@cse.unsw.edu.au>
	<44972AF1.8040500@nigelterry.net>
	<17559.13371.751956.423312@cse.unsw.edu.au>
	<449734AE.10907@nigelterry.net>
	<4497CF71.5050906@nigelterry.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Nigel J. Terry on Tuesday June 20
Sender: linux-raid-owner@vger.kernel.org
To: "Nigel J. Terry" <nigel@nigelterry.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday June 20, nigel@nigelterry.net wrote:
> Nigel J. Terry wrote:
> 
> Well good news and bad news I'm afraid...
> 
> Well I would like to be able to tell you that the time calculation now 
> works, but I can't. Here's why: Why I rebooted with the newly built 
> kernel, it decided to hit the magic 21 reboots and hence decided to 
> check the array for clean. The normally takes about 5-10 mins, but this 
> time took several hours, so I went to bed! I suspect that it was doing 
> the full reshape or something similar at boot time.
> 

What "magic 21 reboots"??  md has no mechanism to automatically check
the array after N reboots or anything like that.  Or are you thinking
of the 'fsck' that does a full check every so-often?


> Now I am not sure that this makes good sense in a normal environment. 
> This could keep a server down for hours or days. I might suggest that if 
> such work was required, the clean check is postponed till next boot and 
> the reshape allowed to continue in the background.

An fsck cannot tell if there is a reshape happening, but the reshape
should notice the fsck and slow down to a crawl so the fsck can complete...

> 
> Anyway the good news is that this morning, all is well, the array is 
> clean and grown as can be seen below. However, if you look further below 
> you will see the section from dmesg which still shows RIP errors, so I 
> guess there is still something wrong, even though it looks like it is 
> working. Let me know if i can provide any more information.
> 
> Once again, many thanks. All I need to do now is grow the ext3 filesystem...
.....

> ...ok start reshape thread
> md: syncing RAID array md0
> md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
> md: using maximum available idle IO bandwidth (but not more than 200000 
> KB/sec) for reconstruction.
> md: using 128k window, over a total of 245111552 blocks.
> Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP:
> <0000000000000000>{stext+2145382632}
> PGD 7c3f9067 PUD 7cb9e067 PMD 0
....
> Process md0_reshape (pid: 1432, threadinfo ffff81007aa42000, task 
> ffff810037f497b0)
> Stack: ffffffff803dce42 0000000000000000 000000001d383600 0000000000000000
>        0000000000000000 0000000000000000 0000000000000000 0000000000000000
>        0000000000000000 0000000000000000
> Call Trace: <ffffffff803dce42>{md_do_sync+1307} 
> <ffffffff802640c0>{thread_return+0}
>        <ffffffff8026411e>{thread_return+94} 
> <ffffffff8029925d>{keventd_create_kthread+0}
>        <ffffffff803dd3d9>{md_thread+248} 

That looks very much like the bug that I already sent you a patch for!
Are you sure that the new kernel still had this patch?

I'm a bit confused by this....

NeilBrown
