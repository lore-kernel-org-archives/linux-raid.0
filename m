From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID5 won't mount after reducing disks from 8 to 6
Date: Wed, 16 Feb 2011 20:30:27 -0500
Message-ID: <4D5C7A33.90007@turmel.org>
References: <C2D86BF5-AECE-49B3-B139-1CD6375DCFC9@mac.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C2D86BF5-AECE-49B3-B139-1CD6375DCFC9@mac.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Tehonica <matt.tehonica@mac.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/16/2011 07:24 PM, Matt Tehonica wrote:
> Hi all,
> 
> I converted my RAID5 from 8 disks to 6 disks using "mdadm --grow /dev/md0 --array-size" and then "mdadm --grow /dev/md0 --raid-devices=6" and after rebooting, it won't mount.  It has been running fine for about a year.  File system is XFS.  Here is some info on it....

Did you resize (shrink) the XFS filesystem first?

