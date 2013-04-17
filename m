From: Robert L Mathews <lists@tigertech.com>
Subject: Re: Use RAID-6!
Date: Tue, 16 Apr 2013 20:32:39 -0700
Message-ID: <516E17D7.2030906@tigertech.com>
References: <15345091.8.1366130671716.JavaMail.root@zimbra> <516DABF2.5050409@tigertech.com> <516DAF21.5040409@aei.mpg.de> <516DD433.50100@tigertech.com> <516DEAD4.7080305@bucksch.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <516DEAD4.7080305@bucksch.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 4/16/13 5:20 PM, Ben Bucksch wrote:

> However, I think the RAID5 problems are caused by bad design decisions
> in the md implementation, not in the inherent concept of RAID5, though.

I'm not so sure this is true. I once lost (backup) data on a proprietary
non-mdadm RAID 5 system, too, because some spurious event caused
problems for multiple drives at once.

With mdadm, at least there's the opportunity to fix something with the
raw disks, which proprietary systems don't allow. Knowing the right
recovery steps to take is complex and easy to screw up, but there are
many different things that could have gone wrong in the first place.

As Adam Goryachev said, it's amazing how many of the the "my RAID died
*and* I did something foolish" stories do end with getting the data
back. This speaks well of the flexibility and power of mdadm in the true
Unix sense, I think.

-- 
Robert L Mathews, Tiger Technologies, http://www.tigertech.net/
