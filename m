From: liyiming <liyiming@nrchpc.ac.cn>
Subject: I think there is a trick to improve performance of md.
Date: Fri, 15 Sep 2006 11:57:50 +0800
Message-ID: <450A24BE.3090102@nrchpc.ac.cn>
References: <200609121714.58541.clive@vacuumtube.org.uk> <17670.56982.310173.651209@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17670.56982.310173.651209@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

blow are some codes in md_do_sync function of md.c in 
linux-2.6.17.11-rc5/drivers/md

4774: int next = (last_mark+1) % SYNC_MARKS;

I have no idea why SYNC_MARKS is set 10. if set SYNC_MARKS to 8 or 
16(the power of 2), we can replace the % operation to  & operation
and this trick will accelerate the running of this code.
 
