From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: [ANNOUNCE][PATCH 2.6] md: persistent (file-backed) bitmap and async
 writes
Date: Fri, 13 Feb 2004 15:58:46 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <402D3A86.97CF894F@SteelEye.com>
References: <40198E85.29EBC8E0@SteelEye.com>
		<16422.62911.755570.855200@notabene.cse.unsw.edu.au>
		<4027E342.D02202F1@SteelEye.com> <16424.8182.876520.280031@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org, ptb@it.uc3m.es, mingo@redhat.com, "james.bottomley" <james.bottomley@SteelEye.com>
List-Id: linux-raid.ids

And here is the next set of patches. Tested thoroughly against
2.6.2-rc2-bk3 and compile tested against 2.6.3-rc2.

I've split the kernel code into two patches. The async write patch is
dependent on the bitmap patch. The bitmap patch includes the new
GET/SET_EXTRA_ARRAY_INFO ioctls and a mempool for the bitmap_update
structures (no more -ENOMEM in the I/O request path). 

bitmap patch vs. 2.6.3-rc2
--------------------------
http://parisc-linux.org/~jejb/md_bitmap/md_bitmap_2_30_2_6_3_RC2.diff 

async write patch vs. 2.6.3-rc2
-------------------------------
http://parisc-linux.org/~jejb/md_bitmap/md_async_2_30_2_6_3_RC2.diff

mdadm patch vs. 1.5.0
---------------------
http://parisc-linux.org/~jejb/md_bitmap/mdadm_1_5_0-2.diff


For simplicity's sake, the mdadm patch includes both the bitmap and
async code (it's a fairly small patch anyway, and probably wouldn't have
benefited much from a split).

--
Paul
