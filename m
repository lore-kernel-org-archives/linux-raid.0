From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm and raid5 hot-rebuild problem on 2.5.67
Date: Wed, 16 Apr 2003 11:48:25 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16028.46697.488363.56989@notabene.cse.unsw.edu.au>
References: <1050536716.13739.6.camel@testlin.hades>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Stef Telford on  April 16
To: Stef Telford <stef@chronozon.artofdns.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On  April 16, stef@chronozon.artofdns.com wrote:
> 
> [root@survivor root]# mdadm --manage /dev/md0 -a
> /dev/ide/host4/bus0/target0/lun0/part2
> mdadm: add new device failed for /dev/ide/host4/bus0/target0/lun0/part2:
> Device or resource busy

Do you get any kernel messages at the same time as this error?

NeilBrown
