From: alexander.weber@pta.de
Subject: Antwort: Re: RAID1-Device won't survive reboot
Date: Thu, 9 Oct 2003 14:12:50 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <OF52E3583F.70A92C60-ONC1256DBA.00429AA3@pta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: alpha@steudten.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


That's it! I didn't pay enough attention to the partition table. /dev/hda1
indeed has type 83 (Linux).

It is not as complicated as I thought. ;-)
Thanks for your help!!

Alexander




                                                                                                                   
                    Thomas                                                                                         
                    Steudten            An:      rob <rob@fantinibakery.com>                                       
                    <alpha@steudt       Kopie:   alexander.weber@pta.de, linux-raid@vger.kernel.org                
                    en.com>             Thema:   Re: RAID1-Device won't survive reboot                             
                                                                                                                   
                    09.10.2003                                                                                     
                    14:00                                                                                          
                    Bitte                                                                                          
                    antworten an                                                                                   
                    alpha                                                                                          
                                                                                                                   
                                                                                                                   





I think the partition is not marked with type fd: like
mime: It must be type "fd"

[1021] (1) #  fdisk -l /dev/sda

Disk /dev/sda: 64 heads, 32 sectors, 35003 cylinders
Units = cylinders of 2048 * 512 bytes

    Device Boot    Start       End    Blocks   Id  System
/dev/sda1             1      8676   8884208   fd  Linux raid autodetect
/dev/sda2          8677     35003  26958848   83  Linux



rob wrote:

> I'm not familiar with SuSE 8.2,   but here are some hints:
>
> -is it possible that  either the mount of md0 is getting done before
> md0 is assembled, or hdb1  is getting mounted directly?  check  df -v
> right after boot.
>

>>







**********************************************************************
http://www.pta.de
Mit 788 Erfahrungsberichten aus 34 Jahren erfolgreicher Projektarbeit!
**********************************************************************

