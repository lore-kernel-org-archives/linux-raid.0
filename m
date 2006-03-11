From: Ming Zhang <mingz@ele.uri.edu>
Subject: how to clone a disk
Date: Fri, 10 Mar 2006 19:56:02 -0500
Message-ID: <1142038562.20484.234.camel@localhost.localdomain>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi folks

I have a raid5 array that contain 4 disk and 1 spare disk. now i saw one
disk have sign of going fail via smart log.

so i am trying to do this

1) pull that disk (A) out
2) using dd to copy that disk (A) to another same one (B);
3) put disk (B) back to raid5 and assume that bitmap can help me resync
quickly.

now my question is 
1) can this achieve my goal?
2) is there any better/correct way?

thanks!

Ming


