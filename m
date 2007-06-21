From: David Greaves <david@dgreaves.com>
Subject: Re: limits on raid
Date: Thu, 21 Jun 2007 09:59:36 +0100
Message-ID: <467A3DF8.2080008@dgreaves.com>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm> <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm> <18034.3676.477575.490448@notabene.brown> <467273AB.9010202@argo.co.il> <18035.3009.568832.785308@notabene.brown> <20070618045759.GD85884050@sgi.com> <18041.59628.370832.633244@notabene.brown> <20070621063936.GT85884050@sgi.com> <Pine.LNX.4.64.0706202341080.31603@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706202341080.31603@asgard.lang.hm>
Sender: linux-raid-owner@vger.kernel.org
To: david@lang.hm
Cc: David Chinner <dgc@sgi.com>, Neil Brown <neilb@suse.de>, Avi Kivity <avi@argo.co.il>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

david@lang.hm wrote:
> On Thu, 21 Jun 2007, David Chinner wrote:
> one of the 'killer features' of zfs is that it does checksums of every 
> file on disk. so many people don't consider the disk infallable.
> 
> several other filesystems also do checksums
> 
> both bitkeeper and git do checksums of files to detect disk corruption

How different is that to raid1/5/6 being set to a 'paranoid' "read-verify" mode 
(as per Dan's recent email) where a read reads from _all_ spindles and verifies 
(and with R6 maybe corrects) the stripe before returning it?

Doesn't solve DaveC's issue about the fs doing redundancy but isn't that 
essentially just fs level mirroring?

David
