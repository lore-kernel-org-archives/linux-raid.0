From: M K <maheshext3@yahoo.com>
Subject: Re: Autodetect problem w/ SCSI
Date: Tue, 1 Jun 2004 13:45:16 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040601204516.24507.qmail@web61004.mail.yahoo.com>
References: <20040601183951.GA22078@bluff>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040601183951.GA22078@bluff>
To: Sandro Dentella <sandro.dentella@tin.it>, Linux Raid List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Can you send the exact command used to create the
array, the raidtabs or mdadm.conf file and the fdisk
-l listing of each drive thats part of the raid?
--- Sandro Dentella <sandro.dentella@tin.it> wrote:
> 
> 
> I made plenty of RAID1 systems w/ ide disk: OK.
> Now I tried a SCSI system and I can't make the
> kernel recognize the partition
> to make into an array. Of course partitions are
> 'fd': raid autodetect.
> 
> Kernel recognizes the scsi hw (aic7xxx compiled in),
> then starts  
> "md: Autodetecting RAID arrays"  that will just fail
> to find the arrays.
> 
> If I start from a live CD, I can "mdadm -A /dev/md0
> /dev/sda6 /dev/sdb6" and
> the array starts and I can mount it.
> 
> Is there something peculiar of SCSI systems I'm just
> ignoring?
> 
> 
> 
> TYA
> 
> sandro
> *:-)
> 
> 
> I'm sorry to admit it's quite URGENT to me to get to
> a solution... this is a
> replacement for a customer after 4 ide disks failure
> in 5 months...
> 
> 
> 
> -- 
> Sandro Dentella  *:-)
> e-mail: sandro.dentella@tin.it 
> http://www.tksql.org                    TkSQL Home
> page - My GPL work
> -
> To unsubscribe from this list: send the line
> "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
http://vger.kernel.org/majordomo-info.html



	
		
__________________________________
Do you Yahoo!?
Friends.  Fun.  Try the all-new Yahoo! Messenger.
http://messenger.yahoo.com/ 
