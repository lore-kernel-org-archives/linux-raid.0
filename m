From: Jules Bean <jules@jellybean.co.uk>
Subject: Re: After partition resize, RAID5 array does not assemble on boot
Date: Wed, 04 Jun 2008 14:14:11 +0100
Message-ID: <48469523.4050601@jellybean.co.uk>
References: <4844E994.8020808@jellybean.co.uk>    <4845B573.7090801@jellybean.co.uk> <48675.192.168.1.70.1212528422.squirrel@neil.brown.name> <484636B9.20700@jellybean.co.uk> <48464B3A.7070206@dgreaves.com> <4846529B.1000809@jellybean.co.uk> <484681AF.8030004@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <484681AF.8030004@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Greaves wrote:
>> I don't really see that it's "safer" though. I would have thought it was
>> quicker but potentially less safe.
> 
> Avoiding a lot of time stress testing the disks in degraded mode isn't 'safer'?

Stress testing the disks by an md rebuild is a feature! It increases 
confidence that they work.

;)

Seriously, I understand your point now. Yes, a rebuild-free partition 
resize would be a nice feature. So would a "help, please find my 
superblock by exhaustive scanning" utility ;)

Jules
