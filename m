From: Krzysztof Adamski <k@adamski.org>
Subject: raid upgrade form 1.5T to 3T drives with 0.90 superblock
Date: Thu, 23 Jun 2011 14:43:15 -0400
Message-ID: <1308854595.23175.65.camel@oxygen.netxsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,

I have a raid6 array made out of 8 1.5T drives and I wanted to change to
use 3T drives. The array is 0.90. After reading the wiki I see that 0.90
superblock will not work with any device larger then 2T.

What are my options for a live upgrade (backup/restore is not possible)?

Thanks in advance.
K

