From: Bryan Hepworth <bryan.hepworth@newcastle.ac.uk>
Subject: RE: restarting raid arrays with uuid
Date: Thu, 9 Jun 2016 12:23:56 +0000
Message-ID: <DB5PR07MB12871D31BEA5758738234478D55F0@DB5PR07MB1287.eurprd07.prod.outlook.com>
References: <DB5PR07MB1287703757699A1962149D82D55C0@DB5PR07MB1287.eurprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <DB5PR07MB1287703757699A1962149D82D55C0@DB5PR07MB1287.eurprd07.prod.outlook.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>-----Original Message-----
>From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
>owner@vger.kernel.org] On Behalf Of Bryan Hepworth
>Sent: 06 June 2016 19:55
>To: linux-raid@vger.kernel.org
>Subject: restarting raid arrays with uuid
>
>Hi All
>
>I'm not entirely sure this is rescuable. This is an old system that was kept on
>for scratch storage space, unfortunately it was discovered some data hadn't
>moved out of this area. The arrays disappeared after taking them offline and
>rebooting the machine.
>
>I've checked /etc/mdadm.conf
>And mdadm --examine across all of the disks
>I've assembled from uuid
>Ran /proc/mdstat
>
>Any suggestions as to what to try next?
>

After carefully looking at the arrays I have two back as they should be.

I've also discovered that one of the drives with gpt has a partition in it with ext4 data. Gparted has given me the device uuid which I can see in /dev/disk/by-uuid

Unfortunately it says no superblock information when I run mdadm --examine /dev/disk/by-uuid/<uuid number>

gparted  does say ext4 is clean and it does have a --raid tag so my next question is is it safe to mount this drive, or is it best to dd it elsewhere to see what's on it?

Thanks

Bryan
