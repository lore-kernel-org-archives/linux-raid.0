From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: about delete raid
Date: Fri, 24 May 2002 10:45:43 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15597.36151.33180.336611@notabene.cse.unsw.edu.au>
References: <OF46EF560E.DDE1731B-ON48256BC2.00497654@legend.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from lilha@legend.com.cn on Thursday May 23
To: lilha@legend.com.cn
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday May 23, lilha@legend.com.cn wrote:
> [root@snap /root]# mkraid /dev/md9
> handling MD device /dev/md9
> analyzing super-block
> /dev/hda8: device too small (0kB)
> mkraid: aborted, see the syslog and /proc/mdstat for potential clues.
> 
> 
> Can you tell me where is wrong?
> thanks a lot.

My best guess is that you need to reboot for the changes to the
partition table to be read.
What does 'cat /proc/partitions' show?

NeilBrown
