From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: mdadm.conf unnecessary?
Date: Tue, 22 Apr 2008 10:02:00 +1200
Message-ID: <480D0ED8.20704@sauce.co.nz>
References: <200804212345.20631.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200804212345.20631.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dexter Filmore wrote:

> So the new disks will be sd[efgh]1.
> But when I pull the old drives after migrating, they will be sd[abcd]1.. so... 
> how do I handle this?

Make an mdadm.conf file that reflects your current array and use UUID's 
to identify the arrays - here is an example:

ARRAY /dev/md5 level=raid5 num-devices=4 
UUID=32cd6355:3c2c08a3:970a9f77:c13e51a3

Note, this should be all one line.

This will ensure that regardless of which /dev/sdX a drive is, the array 
will be assembled only from drives which are using this UUID.

mdadm -D /dev/mdX where X is your current array will give you the UUID 
of this array.

Regards,

Richard
