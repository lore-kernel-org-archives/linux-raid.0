From: Paul Kubicz <pkube@umich.edu>
Subject: raid0_make_request bug: can't convert ...bigger than 8k
Date: Fri, 14 Jun 2002 14:08:00 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3D0A3100.9010506@umich.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm getting a message like this when trying to compile raid into the 
2.5.x kernel (up to 2.5.21). I've picked up several semi-relevant 
messages in a search, but I couldn't find anything that directly 
addresses the problem.

I'm trying to mount md0 created under kernel 2.4.x. Thanks for any help.




