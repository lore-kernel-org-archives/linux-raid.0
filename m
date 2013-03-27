From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Possible to change chunk size on RAID-1 without re-init or
 destructive result?
Date: Wed, 27 Mar 2013 06:56:43 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1303270653120.11255@uplift.swm.pp.se>
References: <CAFCYAsfriik8VAPV9MVhsDtgqHTaKs3kzYoSLVQHaiYKfzjXZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFCYAsfriik8VAPV9MVhsDtgqHTaKs3kzYoSLVQHaiYKfzjXZw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 26 Mar 2013, Jeff Johnson wrote:

> I know I would have to set a different chunk size in the superblock. 
> Google and wiki research do not show a clear method to do this.

Google results for <mdadm change chunk size> result number 5 for me is 
<http://neil.brown.name/blog/20090817000931>. While this is a few years 
old, it says raid1 can't change chunk size, only RAID5 and RAID6 can 
change chunk size.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
