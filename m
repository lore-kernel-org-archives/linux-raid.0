From: "Edward Siefker" <hatta00@fastmail.fm>
Subject: Re: Raid 5 to 6 grow stalled
Date: Sun, 10 Apr 2011 08:02:43 -0700
Message-ID: <1302447763.8724.1439486933@webmail.messagingengine.com>
References: <1302366232.12096.1439264077@webmail.messagingengine.com>
 <20110410073039.2d9683ac@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110410073039.2d9683ac@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> 
> Doesn't look good..
> What version of mdadm?  What kernel?
> 
> NeilBrown
> 



root@iblis:~# mdadm --version
mdadm - v3.1.4 - 31st August 2010
root@iblis:~# uname -a
Linux iblis 2.6.38-2-amd64 #1 SMP Tue Mar 29 16:45:36 UTC 2011 x86_64
GNU/Linux

Did you see the other post I made?  The array still
reports as clean, but I haven't tried to mount it yet. 
This array started out as a RAID1, which I changed to
RAID5, added a disk, reshaped, and added a spare to. 
This worked great and I used it for a couple weeks 
before deciding to go to RAID6. 


Looking at the output of 'mdadm -E' and 'mdadm -D'
(again in the other post), it looks like there's 
some inconsistency in the raid device for /dev/sde1.
-E reports it as number 4 and raid device 4. But,
-D says /dev/sde1 is number 4 and raid device 3.
Don't know if that means anything, but it's the 
only thing I see that looks unusual. 

Since the array is clean, is it safe to mount it?
It's actually a luks volume, fwiw.  Thanks
-- 
  
  hatta00@fastmail.fm

-- 
http://www.fastmail.fm - mmm... Fastmail...

