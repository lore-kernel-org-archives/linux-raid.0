From: zhangxiao <xiao.zhang@windriver.com>
Subject: The DM_BUFIO_HASH_BITS is defined as 20, any plan to make it flexible?
Date: Tue, 2 Dec 2014 16:32:14 +0800
Message-ID: <547D790E.3070803@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Hi NeilBrown,

See drivers/md/dm-bufio.c as below:
   50 /*
   51  * Buffer hash
   52  */
   53 #define DM_BUFIO_HASH_BITS      20
   54 #define DM_BUFIO_HASH(block) \
   55         ((((block) >> DM_BUFIO_HASH_BITS) ^ (block)) & \
   56          ((1 << DM_BUFIO_HASH_BITS) - 1))
"drivers/md/dm-bufio.c" 1854L, 45375C 


DM_BUFIO_HASH_BITS was defined as 20 and it maybe not fit for some
use case with limited resources. Do we have any plan to make it more
flexible? Like module parameter or something else?

Thanks
Xiao
