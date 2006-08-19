From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: Can you IMAGE Mirrored OS Drives?
Date: Sat, 19 Aug 2006 03:18:41 +0200
Message-ID: <20060819011841.GH6440@boogie.lpds.sztaki.hu>
References: <44E250CD.5040308@aol.com> <Pine.LNX.4.56.0608160755090.15328@lion.drogon.net> <44E2EE20.9010004@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <44E2EE20.9010004@aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: andy liebman <andyliebman@aol.com>
Cc: gordon@drogon.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Aug 16, 2006 at 06:06:24AM -0400, andy liebman wrote:

> There is absolutely NO PROBLEM making images of single disks and 
> restoring them to new disks (thus, creating clones). And it is very 
> fast. For an OS drive with about 4 GBs of data, it only takes about 5 
> minutes to make the image and 3 to restore it. So, after making the 
> first set of images, it would in theory take under 10 minutes to restore 
> a mirrored pair.

Be prepared that these times will be much larger if you try to clone
RAID5, since by looking at just a single disk the image creator program
will not be able to read the file system and identify which parts of the
partition contain useful data and which parts are empty.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
