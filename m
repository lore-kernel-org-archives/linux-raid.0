From: "Robin Bowes" <robin-lists@robinbowes.com>
Subject: Re: Q: RAID-1 w/2x160GB, ReiserFS, Debian 'woody',
      homebrew 2.4.25 kernel
Date: Wed, 4 Aug 2004 11:37:44 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <54107.194.60.85.4.1091615864.squirrel@194.60.85.4>
References: <ceq7ij$vj7$1@sea.gmane.org>
    <27897.194.60.85.4.1091613610.squirrel@194.60.85.4>
    <200408041129.44767.m.watts@eris.qinetiq.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200408041129.44767.m.watts@eris.qinetiq.com>
To: Mark Watts <m.watts@eris.qinetiq.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, August 4, 2004 11:29, Mark Watts said:
 
> Talking of partitioning several disks the same, is there an easy way to
> automate this?
> 

Yes. Something like:

# sfdisk -d /dev/sda > partition.save
# sfdisk /dev/sdb < partition.save

Or all at once:

# sfdisk -d /dev/sda | sfdisk /dev/sdb

I partition all my drives the same so if one fails it is easy to re-partion the new drive by copying the structure from an existing drive.

R.
-- 
http://robinbowes.com

