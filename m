From: Zhilong <zlliu@suse.com>
Subject: mdadm:compiled warning in mdadm.c:1974:29 treats as errors
Date: Tue, 4 Apr 2017 13:31:33 +0800
Message-ID: <F21EB93E-F788-4981-A8BD-7DA4AFC295F6@suse.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,jes;
  I have found that there is mdfd returns uninitialized warning in mdadm.c. I cannot paste the logs due to I'm on holiday. Please try to issue make everything, you should see it.

Thanks,
-Zhilong 

Send from iPhone
