From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: How best to re-sync raid1 array? zero superblock on removed disk
 and let it rebuild?
Date: Fri, 28 Aug 2015 11:54:20 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1508281152000.13227@uplift.swm.pp.se>
References: <55E02841.9050701@suddenlinkmail.com> <55E02D22.802@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55E02D22.802@suddenlinkmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Cc: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 28 Aug 2015, David C. Rankin wrote:

> Do I try a --re-add on sda7 or just zero it for a complete rebuild? Any 
> help appreciated.

Since sda7 has a much lower event count, it doesn't really matter. You do 
not have a bitmap enabled and so since the event counts are off, a 
complete resync will need to happen either way.

If --re-add doesn't work, use --add. If that doesn't work, zero superblock 
and --add.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
