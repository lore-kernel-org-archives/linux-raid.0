From: Robin Bowes <robin-lists@robinbowes.com>
Subject: Re: new array not starting
Date: Wed, 08 Nov 2006 02:37:17 +0000
Message-ID: <eirfst$pd7$1@sea.gmane.org>
References: <eirdlc$l7j$1@sea.gmane.org> <eiredo$mmo$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <eiredo$mmo$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Robin Bowes wrote:
> This worked:
> 
> # mdadm --assemble --auto=yes  /dev/md2 /dev/sdc /dev/sdd /dev/sde
> /dev/sdf /dev/sdg /dev/sdh /dev/sdi /dev/sdj
> mdadm: /dev/md2 has been started with 8 drives.
> 
> However, I'm not sure why it didn't start automatically at boot. Do I
> need to put it in /etc/mdadm.conf for it to star automatically? I
> thought md start all arrays it found at a start up?

OK, I put /dev/md2 in /etc/mdadm.conf and it didn't make any difference.

This is mdadm.conf (uuids are on same line as ARRAY):

DEVICE partitions
ARRAY /dev/md1 level=raid1 num-devices=2
uuid=300c1309:53d26470:64ac883f:2e3de671
ARRAY /dev/md0 level=raid1 num-devices=2
uuid=89649359:d89365a6:0192407d:e0e399a3
ARRAY /dev/md2 level=raid6 num-devices=8
UUID=68c2ea69:a30c3cb0:9af9f0b8:1300276b

I saw an error fly by as the server was booting saying "/dev/md2 not found".

Do I need to create this device manually?

R.

