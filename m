From: Xinwei Hu <hxinwei@gmail.com>
Subject: Cluster Aware MD Driver
Date: Thu, 14 Jun 2007 03:16:56 +0800
Message-ID: <200706140316.57078.hxinwei@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

  Steven Dake proposed a solution* to make MD layer and tools to be cluster 
aware in early 2003. But it seems that no progressing is made since then. I'd 
like to pick this one up again. :)

  So far as I understand, Steven's proposal still applies to currently MD 
implementation mostly, except we have bitmap now. And bitmap can be 
workarounded via set_bitmap_file.

   The problem is that it seems we need a kernel<->userspace interface to sync 
the mddev struct across all nodes, but I don't find out how.

   I'm new to the MD driver, so correct me if I'm wrong. And you suggestions 
are really appreciated.

   Thanks.

* http://osdir.com/ml/raid/2003-01/msg00013.html
