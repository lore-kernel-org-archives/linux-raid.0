From: Jeff Woods <kazrak+kernel@cesmail.net>
Subject: Re: ICH5 docs
Date: Wed, 31 Dec 2003 00:40:10 -0800
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <6.0.1.1.0.20031231003359.024626f0@no.incoming.mail>
References: <20031230164953.GB4868@atrey.karlin.mff.cuni.cz>
 <3FF1B43A.9090707@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <3FF1B43A.9090707@pobox.com>
References: <20031230164953.GB4868@atrey.karlin.mff.cuni.cz>
 <3FF1B43A.9090707@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Karel Kulhavy <clock@atrey.karlin.mff.cuni.cz>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

At 12/30/2003 12:22 PM -0500, Jeff Garzik wrote to linux-kernel:
>Karel Kulhavy wrote:
>>Where can I learn about ICH5 SATA RAID driver in Linux kernel 2.6.0?  I
>
>Intel "RAID" is software RAID.  There isn't any hardware RAID assist...
>So ICH5 looks pretty much just like any other PATA host controller.

Oh?  My understanding (which I admit is very high-level) is that Intel's 
ICH5 southbridge supports SATA; but to get SATA+RAID requires the ICH5R 
southbridge.  If not, what are the practical differences (if any) between 
the ICH5 and ICH5R?

TIA.

--
Jeff Woods <kazrak+kernel@cesmail.net> 
