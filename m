From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: bug: 4-disk md raid10 far2 can be assembled clean with only two
 disks, causing silent data corruption
Date: Tue, 25 Sep 2012 07:00:44 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1209250658250.13902@uplift.swm.pp.se>
References: <50606207.7040804@gooseman.cz> <20120925141959.0c22de7d@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120925141959.0c22de7d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: =?ISO-8859-15?Q?Jakub_Hus=E1k?= <jakub@gooseman.cz>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 25 Sep 2012, NeilBrown wrote:

> Why do you say that "the write IO errors are invisible for the 
> filesystem"? They are certainly reported in the kernel logs that you 
> should and I'm sure an application would see them if it checked return 
> status properly.
>
> md is behaving as designed here.  It deliberately does not fail the 
> whole array, it just fails those blocks which are no longer accessible.

I would imagine OP would be helped by mounting filesystem with 
"errors=remount-ro" to make sure the filesystem stops writing to the 
drives upon errors.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
