From: Friedrich Lobenstock <fl@fl.priv.at>
Subject: Re: mdadmin can't re-sync a mirror?!
Date: Sat, 25 Jan 2003 01:55:33 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E31E085.5020402@fl.priv.at>
References: <Pine.LNX.4.44.0301241529360.26021-100000@pcmy.sei.cmu.edu>
Reply-To: Linux RAID Mailing Liste <linux-raid@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0301241529360.26021-100000@pcmy.sei.cmu.edu>
To: Linux RAID Mailing Liste <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi!

James Ralston wrote:
> 
> Have I completely misunderstood how Linux software RAID is supposed to
> work?  (I certainly hope so, because otherwise, it can't even perform
> the simplest of recovery operations: replacing a failed mirror
> component and re-syncing.)

Try

   # mdadm --fail /dev/md0 /dev/sdc1
   # mdadm --remove /dev/md0 /dev/sdc1
   # mdadm --zero-superblock /dev/sdc1
   # mdadm --add /dev/md0 /dev/sdc1

This works for me.

-- 
MfG / Regards
Friedrich Lobenstock
____________________________________________________________________
Friedrich Lobenstock         FL226-RIPE             Internetservices
URL: http://www.fl.priv.at/                     Email: fl@fl.priv.at
____________________________________________________________________

