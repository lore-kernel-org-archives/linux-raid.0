From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Proper partition type for components with V1.x superblocks?
Date: Wed, 11 Jun 2008 11:26:22 +0200
Message-ID: <484F9A3E.7020709@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

The subject pretty much says it all - it obviously is not 0xFD, since there is 
nothing to autodetect. Is there some best practice/semi-standard way of 
marking a raid component partition as such? After reading the specs 0xDA 
(non-fs data) comes to mind, but I figured I'll ask here.

Thanks

Peter
