From: M K <maheshext3@yahoo.com>
Subject: Re: raid on extended partitions
Date: Tue, 1 Jun 2004 08:13:12 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040601151312.72047.qmail@web61003.mail.yahoo.com>
References: <16571.56114.265798.791241@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16571.56114.265798.791241@cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--- Neil Brown <neilb@cse.unsw.edu.au> wrote:
> 
> What does
>    ls -l /dev/hd[eg]5
> show? How about
>    cat /proc/partitions
>    dd if=/dev/hde5 of=/dev/null bs=1024k

Thanks a lot, Neil, turns out those nodes were not
present. After I mknod'd them, all's fine in
RAIDland... 
  Quick question: does using extended partitions for
RAID affect performance?
Cheers,
Mahesh



	
		
__________________________________
Do you Yahoo!?
Friends.  Fun.  Try the all-new Yahoo! Messenger.
http://messenger.yahoo.com/ 
