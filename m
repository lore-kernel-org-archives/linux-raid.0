From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Raidstop /dev/md0 won't work
Date: Fri, 3 May 2002 15:00:58 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15570.6538.877456.348186@notabene.cse.unsw.edu.au>
References: <3CD1AF20.45E85EC8@cognigencorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Scott Walter on Thursday May 2
To: Scott Walter <walter@cognigencorp.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday May 2, walter@cognigencorp.com wrote:
> this is probably a very dumb question.. however I am not able to
> raidstop my raid-array using, which i need to do before running
> raidreconf.
> 
> %> raidstop /dev/md0
> /dev/md0: Device or resource busy.
> %>
> 
> any suggestions... i have already tried unmounting the device.

This is a bug in raidstop.  If you strace you will notice that it
opens it twice and before trying to ioctl(STOP...) it.

Upgrade raidtools or use mdadm.

And a quick and dirty:

   mv /dev/md0 /dev/mdx
   mv /dev/md1 /dev/md0
   mv /dev/mdx /dev/md0
   raidstop /dev/md1
   mv /dev/md0 /dev/mdx
   mv /dev/md1 /dev/md0
   mv /dev/mdx /dev/md0

should work.

NeilBrown

> 
> thanks.
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
