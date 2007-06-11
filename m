From: Neil Brown <neilb@suse.de>
Subject: Re: spare group
Date: Tue, 12 Jun 2007 09:47:56 +1000
Message-ID: <18029.57132.285522.284156@notabene.brown>
References: <466D51EE.7030509@avaxio.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Tomka Gergely on Monday June 11
Sender: linux-raid-owner@vger.kernel.org
To: tomka@avaxio.net
Cc: "Linux, Raid lista" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday June 11, tomka@avaxio.net wrote:
> 
> # cat /etc/mdadm/mdadm.conf
> DEVICE /dev/sd[a-g]1
> 
> HOMEHOST ursula
> 
> ARRAY /dev/md1 level=raid5 devices=/dev/sd[defg]1 num-devices=3 
> spares=1 spare-group=ubul name=ursula:T2 
> UUID=fb8ece28:9a6a31f8:700f37f6:7ee91bcf
> ARRAY /dev/md0 level=raid5 devices=/dev/sd[abc]1 num-devices=3 
> spare-group=ubul name=ursula:T1 UUID=3e420024:281f9bb1:fd9ef39b:c18153b1

You don't want the "devices=" entries in there.  If you leave them
there, and sdg1 does get moved to md0, then on the next restart, md0
won't get assembled properly.

> 
> According to the source:
> 
> * If an array has active < raid && spare == 0 && spare_group !=NULL
> * Look for another array with spare > 0 and active == raid and same 
> spare_group
> * if found, choose a device and hotremove/hotadd
> 
> This is not happening. What is my mistake?

Is "mdadm --monitor" running?  That is required to perform
spare-migration.

NeilBrown
