From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Comments on printing out right raid type?
Date: Thu, 20 Nov 2008 06:59:37 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0811200658030.26275@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,

Someone had submitted a patch to correct part of the problem I was 
mentioning earlier, while it may be trivial, do you and others think it 
would be worthwhile to print "raid6" when it is a raid6 rather than 
printing raid5 for most messages in the kernel?

Shouldn't the kernel be accurate when detecting arrays as far as 
informational purposes go?

Justin.
