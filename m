From: Ross Vandegrift <ross@willow.seitz.com>
Subject: Re: RAID1 help
Date: Mon, 9 Jun 2003 11:48:02 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030609154802.GB24153@willow.seitz.com>
References: <20030608211051.GA17000@willow.seitz.com> <529E44D4-99F7-11D7-8B62-000393795060@fifreak.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <529E44D4-99F7-11D7-8B62-000393795060@fifreak.dyndns.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Jun 08, 2003 at 05:22:35PM -0400, Jason Gordon wrote:
> Also recall I was able to
> get the system to boot using 2 out of the 3 possible combinations
> (booting with drives 1 & 2 attached works, booting with drive 1
> attached works, but booting with just drive 2 attached gives me the
> kernel panic).  This is with all of the various parameters in lilo.conf
> referring to /dev/md* devices.

Hmmm, well if your kernel is mountiing /dev/mdx as root, then you've got
the driver issue figured out.

It sounds like perhaps you're missing the raid-extra-boot line (the
howto you listed on docman.sf.net describes it)?  This should load
complete boot stuff onto any disks you specify on the configuration
line.  If you're using LBA32, ignore the notes about a /boot partition -
you shouldn't need it anymore.

Now I'm gonna have to go over these docs and figure out what they did to
get it working with stock kernels that I missed!

-- 
Ross Vandegrift
ross@willow.seitz.com

A Pope has a Water Cannon.                               It is a Water Cannon.
He fires Holy-Water from it.                        It is a Holy-Water Cannon.
He Blesses it.                                 It is a Holy Holy-Water Cannon.
He Blesses the Hell out of it.          It is a Wholly Holy Holy-Water Cannon.
He has it pierced.                It is a Holey Wholly Holy Holy-Water Cannon.
He makes it official.       It is a Canon Holey Wholly Holy Holy-Water Cannon.
Batman and Robin arrive.                                       He shoots them.
