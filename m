From: Bernd Fischer <bernd@begu.net>
Subject: Re: mbr-install for Raid 1, rerun Lilo necessary?
Date: Wed, 06 Oct 2004 18:16:57 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <41641A79.6030709@begu.net>
References: <20041005093440.2b639e71@zrr.local>	<41626483.60505@tls.msk.ru> <20041006105620.465baff7@zrr.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20041006105620.465baff7@zrr.local>
To: RAID Linux <linux-raid@vger.kernel.org>
Cc: "Zeno R.R. Davatz" <zdavatz@ywesee.com>
List-Id: linux-raid.ids

Zeno R.R. Davatz wrote:

>> No, you would have to use boot=/dev/md0 in your lilo.conf,

> Do I have to run 'lilo -v' so lilo gets this?

As usual, you have to run lilo everytime you install a new kernel or 
edit lilo.conf

> Because whenever I run lilo -v (22.5.8) with 'boot=/dev/md0 I get the wonderful Error of:
> Fatal: Trying to map files from unnamed device 0x0000 (NFS ?)

> Any hints?

I had the same problem some time ago. AFAIR it went away when I updated 
to lilo 22.6
As a workaround, create a symlink to /dev/md0 ( e.g. /dev/MD0 ) and use 
this as your boot device in lilo.conf.

Bernd Fischer
