From: George Shuklin <george.shuklin@gmail.com>
Subject: how to get 'peer disk' in raid configuration?
Date: Thu, 28 Jun 2012 03:51:05 +0400
Message-ID: <4FEB9C69.9060608@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Few days ago met intersting question:

Let assume we have RAID10 on 4 disks. We want to remove two  disks 
without  breaking array.

How we can know which drive is safe to eject? For 1st drive it obvious: 
any of. Second is more complicated: we need eject mirror part of 'second 
pair'.

How we can know exact topology of raid? (--detail does not provide 
enough information, IMHO).
