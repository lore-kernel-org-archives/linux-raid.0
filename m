From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Soft-/Hardware RAID Performance
Date: Thu, 20 Feb 2003 11:03:58 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15956.7022.920091.62020@notabene.cse.unsw.edu.au>
References: <5.1.0.14.0.20030219202741.027d3ec0@195.90.31.33>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Daniel Brockhaus on Wednesday February 19
To: Daniel Brockhaus <joker@astonia.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday February 19, joker@astonia.com wrote:
> 
> Performance issues aside. If I go for the software RAID10: How can I 
> configure the system to use the fifth drive as hot spare for both RAID1 
> arrays? Is it save to add the same drive to both arrays (haven't tried it 
> yet)? And would you say that software RAID is stable enough to use in a 
> production system?

This can be done using mdadm in --monitor mode.
If the manual page doesn't make it sufficiently clear, ask and I will
improve the manual page.


mdadm is available from
   http://www.kernel.org/pub/linux/utils/raid/mdadm/

NeilBrown
