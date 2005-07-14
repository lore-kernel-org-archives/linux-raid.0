From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: disk failed, operator error: Now can't use RAID
Date: Thu, 14 Jul 2005 17:03:57 +1000
Message-ID: <17110.3677.293133.503161@cse.unsw.edu.au>
References: <7500724905071314574a13d966@mail.gmail.com>
	<7500724905071317297f7277a7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Hank Barta on Wednesday July 13
Sender: linux-raid-owner@vger.kernel.org
To: Hank Barta <hbarta@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday July 13, hbarta@gmail.com wrote:
> 
> I would very much appreciate suggestions on how to get the raid
> running again.

Remove the 
>    devices=/dev/hde1,/dev/sdd1,/dev/sdc1,/dev/sdb1,/dev/sda1

line from mdadm.conf (it is wrong and un-needed).

Then
  mdadm -S /dev/md0  # just to be sure
  mdadm -A /dev/md0 -f /dev/sd[abcd]1 /dev/hd[eg]1

and see if that works.

NeilBrown
