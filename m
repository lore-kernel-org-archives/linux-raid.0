From: David Greaves <david@dgreaves.com>
Subject: Re: After partition resize, RAID5 array does not assemble on boot
Date: Fri, 06 Jun 2008 15:42:11 +0100
Message-ID: <48494CC3.5050805@dgreaves.com>
References: <4844E994.8020808@jellybean.co.uk>    <4845B573.7090801@jellybean.co.uk> <48675.192.168.1.70.1212528422.squirrel@neil.brown.name> <484636B9.20700@jellybean.co.uk> <48464B3A.7070206@dgreaves.com> <4846529B.1000809@jellybean.co.uk> <484681AF.8030004@dgreaves.com> <48469523.4050601@jellybean.co.uk> <4849412D.9030607@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4849412D.9030607@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Jules Bean <jules@jellybean.co.uk>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen wrote:
> What is needed is to do something like assume-clean on the old data and
> a sync on the new chunks. I don't see that there is a remotely safe way
> to do that,

I assumed that --grow --size=max on a v1.2 superblock would do exactly that...
(well, start a resync at the old partition-end location anyway).

David
