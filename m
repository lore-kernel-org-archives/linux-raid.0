From: Xu Yuehai <raid.yuehai@gmail.com>
Subject: Does raid5 have error handling while reading?
Date: Fri, 22 May 2009 16:10:07 +0800
Message-ID: <691c243c0905220110y541ab523v5998b8054c89da60@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Trace Green <green.trace@gmail.com>
List-Id: linux-raid.ids

I know that if the read request of raid5 is handled by
chunk_aligned_read, there is no error handling in raid5. But, if this
read request is not aligned, that's say, raid5 need stripe_head to
deal with this request. I find in the code of 2.6.27 that there is no
error handling if this read request fail, I remember in older kernel,
some operations should be done such as compute_block. Am I right?
