From: Neil Brown <neilb@suse.de>
Subject: Re: trouble creating array
Date: Mon, 26 Feb 2007 15:40:26 +1100
Message-ID: <17890.25786.772246.970996@notabene.brown>
References: <540638.44700.qm@web55810.mail.re3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from jahammonds prost on Sunday February 25
Sender: linux-raid-owner@vger.kernel.org
To: jahammonds prost <gmitch64@yahoo.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday February 25, gmitch64@yahoo.com wrote:
> 
> 
> Any ideas how to find out what has it open? I can happily write all over the disk with dd... I can create and delete the partition, and it's all good... I will try deleting the sd{b,c}1 partitions, reboot, and see what happens.
> 

ls -l /sys/block/*/holders/* ??

NeilBrown
