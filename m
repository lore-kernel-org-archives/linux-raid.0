From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: recommended way to add ssd cache to mdraid array
Date: Sat, 22 Dec 2012 20:44:27 -0700
Message-ID: <201212222044.27731.thomas@fjellstrom.ca>
References: <201212212357.19292.thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201212212357.19292.thomas@fjellstrom.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri Dec 21, 2012, Thomas Fjellstrom wrote:
> I'm setting up a new nas box (7x2TB on a IBM M1015 8 port sas card flashed
> to 9211IT mode) and was thinking about adding an SSD cache to it. I've
> been following bcache's development, but it seems to have stalled a bit.
> 
> I've got a 240G Samsung 470/810 that I'd like to use for this.
> 
> Also I was wondering if anyone has any tips on the best (or their
> preferred) way to set up a "big" raid6 array with a single filesystem. I'm
> probably going to stick with XFS, but I'm not married to it, if there's
> something better for a big media (audio, video, disk images, backups, etc)
> volume I'd love to hear about it.

So my array has finally finished resyncing, and I've run a simple iozone test 
on it formated with xfs, and I'm seeing some somewhat low write results:

moose@mrbig:/mnt/mrbig/data/test$ iozone -a -s 32G -r 8M
                                                            random  random    
bkwd   record   stride                                   
              KB  reclen   write rewrite    read    reread    read   write    
read  rewrite     read   fwrite frewrite   fread  freread
        33554432    8192  212507  210382   630327   630852  372807  161710  
388319  4922757   617347   210642   217122  717279   716150

Is this normal for a 7 disk (2TB seagate barracudas) raid array on a pcie x8 
sas controller?

I was thinking it might be alignment issues, but there are no partitions on 
the disks, and xfs seems to have correctly set up the sunit and swidth 
settings (128/640 for a 7 disk raid6). While 200MB/s is probably more than I 
need day to day, I'd like to make sure it is set up properly.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
