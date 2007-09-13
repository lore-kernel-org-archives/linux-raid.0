From: Neil Brown <neilb@suse.de>
Subject: Re: RAID6 mdadm --grow bug?
Date: Thu, 13 Sep 2007 12:52:14 +0200
Message-ID: <18153.5726.377390.171544@notabene.brown>
References: <42161BFD-EAE6-4485-8DE6-05D0EBE51A06@fusion.gat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David Miller on Wednesday September 12
Sender: linux-raid-owner@vger.kernel.org
To: David Miller <millerdc@fusion.gat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday September 12, millerdc@fusion.gat.com wrote:
> 
> 
> Problem:
> 
> The mdadm --grow command fails when trying to add disk to a RAID6.
> 
..
> 
> So far I have replicated this problem on RHEL5 and Ubuntu 7.04  
> running the latest official updates and patches. I have even tried it  
> with the most latest version of mdadm 2.6.3 under RHEL5. RHEL5 uses  
> version 2.5.4.

You don't say what kernel version you are using (as I don't use RHEL5
or Ubunutu, I don't know what 'latest' means).

If it is 2.6.23-rcX, then it is a known problem that should be fixed
in the next -rc.  If it is something else... I need details.

Also, any kernel message (run 'dmesg') might be helpful.

NeilBrown
