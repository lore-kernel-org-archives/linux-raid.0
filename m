From: Don Jessup <donj@asaca.com>
Subject: RAID5 temperorary loss two disk
Date: Wed, 28 Apr 2004 07:28:49 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040428142849.68073.qmail@web14525.mail.yahoo.com>
References: <408D0FF0.5000608@uni-mainz.de>
Reply-To: donj@asaca.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <408D0FF0.5000608@uni-mainz.de>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



   I have RAID5 volume that has two disk that have been marked as failed.
   I believe this happen do to loss of communication with the disk. NOT because
   of a total disk failure. I assume if I can get the superblocks back into
    a good state I can reassemble the RAID5 and try to read what data I can
    off the volume.  Does anyone know how to force RAID5 superblocks
    into a state so I can do reads from the volume?   
   I really need help on this.  By the way the kernel version is 2.4.22.

    Thank You
  

--- Dominik Kubla <dominik.kubla@uni-mainz.de> wrote:
> christophe varoqui wrote:
> 
> >>Unfortunately very little effort seems to be spent on documenting the
> features of device-mapper and how to use them. I originally intended to use
> DM, but since i could not find any information on how to configure mirrored
> multipath devices i decided against it.
> >>
> >>What is the word on MD and DM? I miss some sort of road map and a general
> overview (preferrably with executive summary). (I am willing to write one if
> i can find/get the necessary information.)
> >>
> > 
> > I'm quite fond of my docs on multipath with the device-mapper subsystem.
> > You can find them at http://christophe.varoqui.free.fr
> > 
> > Hope it helps.
> > 
> > regards,
> > cvaroqui
> > 
> 
> Excellent! Thanks a lot!
> 
> Dominik
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> 


=====
Don Jessup
Asaca/Shibasoku Corp. of America
400 Corporate Circle, Unit G
Golden, CO  80401
303-278-1111 X232
donj@asaca.com
http://www.asaca.com
