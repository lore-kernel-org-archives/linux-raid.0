From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Desperate: mdadm fails to assemble raid saying devices are
 busy.
Date: Sun, 22 Sep 2013 08:29:12 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1309220828450.32315@uplift.swm.pp.se>
References: <523DADE5.8050604@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <523DADE5.8050604@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sachin Garg <sgarg.bugreporter@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, 21 Sep 2013, Sachin Garg wrote:

> This array contains my /home and I do not know how to recover it.

what does "cat /proc/mdstat" say? Also post mdadm and kernel version.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
