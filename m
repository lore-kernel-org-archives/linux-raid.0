From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID1 failure recovery
Date: Sat, 11 May 2002 07:37:47 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15580.15787.708106.602378@notabene.cse.unsw.edu.au>
References: <200205101133.g4ABXjX28795@mailgate5.cinetic.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Maxim Frolov on Friday May 10
To: Maxim Frolov <wrungel@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday May 10, wrungel@web.de wrote:
> 
> 
> My questions is: How do I recover the failed RAID1 disk (dev/hda1)?
> What I did wrong?
> 
You forgot to set the partition time of /dev/hda1 to "Linux RAID
autodetect" or whatever it is meant to be.

NeilBrown
