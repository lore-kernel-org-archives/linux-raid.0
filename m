From: <rodman@shellport.com>
Subject: RE: Checkarray doesn't seem to do anything
Date: Wed, 02 Mar 2016 12:53:29 -0700
Message-ID: <20160302125329.0a91db92e0d9ae1e5e3fde0508678719.6af0e5bebc.wbe@email03.secureserver.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I, too, get idle on 4.2.0-30.

----
rodman@nas:/media/nas$ dd if=/sys/block/md0/md/sync_action bs=1 count=1
idle
1+0 records in
0+1 records out
5 bytes (5 B) copied, 7.9147e-05 s, 63.2 kB/s
-------

Regards,

Rodman Frowert

-------- Original Message --------
Subject: Re: Checkarray doesn't seem to do anything
From: Roman Mamedov <rm@romanrm.net>
Date: Wed, March 02, 2016 11:47 am
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: rodman@shellport.com, linux-raid@vger.kernel.org

On Wed, 2 Mar 2016 18:44:54 +0100
Piergiorgio Sartor <piergiorgio.sartor@nexgo.de> wrote:

> Just tested:
> 
> dd if=/sys/block/md0/md/sync_action bs=1 count=1
> 
> On kernel 3.x I get "i", on kernel 4.x I get "idle"... :-)

I am getting 'i' on 4.4.1.

# dd if=/sys/block/md0/md/sync_action bs=1 count=1
i1+0 records in
1+0 records out
1 byte (1 B) copied, 0.000218199 s, 4.6 kB/s

-- 
With respect,
Roman
