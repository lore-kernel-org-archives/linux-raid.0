From: Neil Brown <neilb@suse.de>
Subject: Re: Array read 3 time slower to read after data fully loaded
Date: Mon, 22 Nov 2010 15:18:16 +1100
Message-ID: <20101122151816.6ed89c4b@notabene.brown>
References: <4CE4B9E6.1040802@geograph.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CE4B9E6.1040802@geograph.co.za>
Sender: linux-raid-owner@vger.kernel.org
To: Zoltan Szecsei <zoltans@geograph.co.za>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 18 Nov 2010 07:30:14 +0200
Zoltan Szecsei <zoltans@geograph.co.za> wrote:

> Hi,
> Can anyone please explain this to me?
> 
> For the last >30 hours I have been loading some 2.5TB of 200-400MB tiff 
> images, from another PC on our internal network, onto this new array.
> Yesterday, during this load process, I copied 10 of these files (about 
> 2.5GB) from the array onto the /home directory of the same system.
> 
> It took 33 seconds, equating to some 75MB/s.
> 
> This morning I came in to find that the load process had finished, so I 
> deleted the 10 test files from /home, and redid the identical copy test 
> (using bash-history, so: identical).
> 
> It took 123 seconds, equating to some 20MB/s.
> 
> Que? (as in Manuel from Faulty Towers :-)  )

Maybe the first time some of the files were in RAM... how much RAM do you
have, and how recently that the files been loaded before your copied them?

NeilBrown - who has never been to Barcelona.

> 
> 
> Thanks & regards,
> Zoltan
> 
> 
> root@gs0:/home/geograph# uname -a
> Linux gs0 2.6.32-25-generic #45-Ubuntu SMP Sat Oct 16 19:52:42 UTC 2010 
> x86_64 GNU/Linux
> root@gs0:/home/geograph# mdadm -V
> mdadm - v3.1.4 - 31st August 2010
> root@gs0:/home/geograph# lvm version
>    LVM version:     2.02.54(1) (2009-10-26)
>    Library version: 1.02.39 (2009-10-26)
>    Driver version:  4.15.0
> root@gs0:/home/geograph# df  #ext4
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/sdi7            426559760   9494844 395396872   3% /home
> /dev/mapper/geo_vg0-geo_lvm0
>                       11536635672 2530042680 8889387468  23% /mnt/geo_lvm0
> root@gs0:/home/geograph#
> 
> 

