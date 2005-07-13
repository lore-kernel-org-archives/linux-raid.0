From: Rui Santos <rsantos@ruisantos.com>
Subject: Re: How to auto rebuild array?
Date: Wed, 13 Jul 2005 21:45:16 +0100
Message-ID: <42D57D5C.4070601@ruisantos.com>
References: <42D3C998.3F84EF1C@ardistech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42D3C998.3F84EF1C@ardistech.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Bart,

   Is that a RAID1 ou RAID5?

   Can you give the output of these commands?

   mdadm --misc -D /dev/md3
   mdadm --misc -E /dev/hd{a,b,e,f}4

   One other thing. Are you sure that all you raid partitions are marked 
0xfd ?

   Also attach you mdadm.conf/raidconf file, if you have any...

Regards,
Rui Santos

bart@ardistech.com wrote:

>Hi,
>
>I have the problem that after a power failure I get the message:
>
>Jul 12 15:29:17 kernel: md: created md3
>Jul 12 15:29:17 kernel: md: bind<hda4>
>Jul 12 15:29:17 kernel: md: bind<hdb4>
>Jul 12 15:29:17 kernel: md: bind<hde4>
>Jul 12 15:29:17 kernel: md: bind<hdf4>
>Jul 12 15:29:17 kernel: md: running: <hdf4><hde4><hdb4><hda4>
>Jul 12 15:29:17 kernel: md: kicking non-fresh hde4 from array!
>Jul 12 15:29:17 kernel: md: unbind<hde4>
>
>I understand that hde4 is not 'fresh' and the array need to be rebuild
>but I only can do that with 'mdadm --add /dev/md3 /dev/hde4'. I would
>like to have it turned into a hot-spare, in which case a rebuild would
>start automatic.
>
>This application runs unattended, so there is nobody there to enter
>mdadm commands.... How can I make the rebuild starting automatic
>(like a hardware raidcard does)?
>
>Regards,
>	Bart
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>  
>

