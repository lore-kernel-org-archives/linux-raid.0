From: Mark Hahn <hahn@mcmaster.ca>
Subject: Re: trouble creating array
Date: Sun, 25 Feb 2007 22:01:06 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0702252157550.29531@coffee.psychology.mcmaster.ca>
References: <540638.44700.qm@web55810.mail.re3.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <540638.44700.qm@web55810.mail.re3.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: jahammonds prost <gmitch64@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Any ideas how to find out what has it open? I can happily write all over

I think I've heard of other cases like this where it's lvm that's 
glommed onto the partition.  I don't use lvm, but perhaps 'lvdisplay'?
