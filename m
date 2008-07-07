From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Subject: Re: raid10: no raid0 support?
Date: Mon, 07 Jul 2008 08:46:49 -0400
Message-ID: <48721039.7040706@hp.com>
References: <484D9712.7090804@hp.com> <18521.59535.292223.722853@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18521.59535.292223.722853@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Monday June 9, Alan.Brunelle@hp.com wrote:
>> Is there some reason why the MD RAID10 module does /not/ support a
>> "RAID0-like" configuration (-p n1)? The comments in drivers/md/raid10.c
>> seem to suggest it should:  "* If [near_copies and far_copies] are 1, we
>> get raid0." Yet the code specifically checks for ((near_copies *
>> far_copies) > 1).
> 
> You mean:
> 	if ((nc*fc) <2 || (nc*fc) > mddev->raid_disks ||
> 	    (mddev->layout >> 17)) {
> 		printk(KERN_ERR "raid10: %s: unsupported raid10 layout: 0x%8x\n",
> 		       mdname(mddev), mddev->layout);
> 		goto out;
> 	}
> 
> Yes, I guess that could be "nc*fc < 1".  Everything else should still
> work.
> 
> I cannot think of a good reason for making a raid10 with no redundancy though.
> 
>> Just curious, as it seems interesting that one could support RAID0,
>> RAID1 /and/ RAID10 all w/ one RAID module.
> 
> Interesting: yes.
> Useful:  not sure.
> 
> NeilBrown
> 

Sorry for the tardy response (on holiday), just thinking about the
algorithm's application to another problem where having one piece of
code supporting all three RAID modes is goodness...

Thanks,
Alan
