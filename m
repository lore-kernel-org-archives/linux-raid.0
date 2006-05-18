From: Ste <ste@phx6a.ath.cx>
Subject: mdadm: Bitmap size
Date: Fri, 19 May 2006 00:44:40 +0200
Message-ID: <446CF8D8.7030708@phx6a.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all, i have this problem:

I am going to do raid 1 over two virtual devices. These virtual devices 
are two hd situated on other two servers.

The problem is:
A network failure could happen often, and if it happen, i don't want to 
recover all the disks. I want to recover just last changed things.

As i can see the bitmap do exactly this, but the default bitmap is too 
small!
There is no problem to have a bitmap file of 1 Gb, but i can't find the 
way to tell to mdadm the size that he has to use for the bitmap file.

Thanks, Stefano.
