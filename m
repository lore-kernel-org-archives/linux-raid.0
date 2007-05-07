From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: mdadm array not found on reboot
Date: Tue, 08 May 2007 07:53:36 +1200
Message-ID: <463F83C0.9070701@sauce.co.nz>
References: <463F5796.1060808@charter.net> <Pine.LNX.4.64.0705071258410.968@p34.internal.lan> <463F5CA6.6090407@charter.net> <Pine.LNX.4.64.0705071302200.968@p34.internal.lan> <463F5EB6.2090605@charter.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <463F5EB6.2090605@charter.net>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Jeffrey B. Layton wrote:

> 
> CentOS 4.2. I've been reading something about raidautorun. Would help in 
> this case?

Try adding:

DEVICE partitions

to the top of your mdadm.conf and:

auto=part

to the end of your /dev/md1 definition.

eg. ARRAY /dev/md1 level=raid1 num-devices=2 
UUID=e235ee6c:415f1494:23c28b59:afd20140 devices=/dev/sda1,/dev/sdb1 
auto=part

Regards,

Richard
