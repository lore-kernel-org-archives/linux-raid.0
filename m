From: Shwety <shweta0232@gmail.com>
Subject: store a block device information in =?utf-8?b?c2JfaW5mbw==?= struct of ext4 file system
Date: Thu, 8 Sep 2011 20:14:28 +0000 (UTC)
Message-ID: <loom.20110908T220701-321@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
I have created an img file and mounted it with ext4 file system.
I want to store its information in sb_info str of ext4 file system ext4.h header 
file. 
actually i am trying to separately store metadata and the data.For doing 
that i have created an img file and formatted this partition with ext4. 
I need to store this partitions information in the ext4_sb_info struct.I am not 
sure about 
how to modify the code as i am new to this file system. 



