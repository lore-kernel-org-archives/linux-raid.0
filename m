From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Help creating filesystem (xfs) and partitioning
Date: Sun, 28 Jul 2013 18:46:07 -0400
Message-ID: <51F59F2F.2080709@tmr.com>
References: <CAH3kUhFqX5fB0=eYbECxrR_52Yv3_v5oodG=6Z-8L_gcTwiC4Q@mail.gmail.com> <51F19E0F.5000400@tmr.com> <CAH3kUhEMtauLoymUL7k8s==4NtvX=CRzOJhhtfL2EdJzYygd+A@mail.gmail.com> <51F1B478.4050901@hardwarefreak.com> <CAH3kUhHzZ3DoA-mJiQG+27gai1=MZEu6t8JTMtmMvQ7q0ipEoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhHzZ3DoA-mJiQG+27gai1=MZEu6t8JTMtmMvQ7q0ipEoQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <rspadim@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Roberto Spadim wrote:
> ok =] in other words no problem about performace loss, just use one
> xfs per disk, right?
> the second doubt... i was thinking about /boot /home and /, in the
> same partition, should i consider other design? a /boot with ext2 or
> ext3 and a / with xfs?
>
> i'm considering only one partition with swap and one partition with
> raid1+xfs, what you think?
> in a crash (power failure) i will have better rescure with only one
> partition? or many partitions?
>
I would create a /boot partition, root partition, and swap partition on each 
drive and make rais1 to create three devices, with two filesystem, /boot and 
root. My thought is that you rarely change /boot, and that MUST work to get the 
system up, so put it by itself. Also, I'm pretty sure you want ext on the boot 
filesystem, if for no other reason than the code in grub being better tested 
booting from that than any other. I will let someone who is more expert in xfs 
than I discuss any questions you have, boot issues may be urban myth, but I see 
no benefit to using anything else.

Note that I have no solid evidence the other than ext for /boot causes problems, 
but years of trouble free with ext3.

-- 
Bill Davidsen <davidsen@tmr.com>
   "'Nothing to hide' does not imply 'nothing to fear'"
       - me
   "AT&T could not seriously contend that a reasonable entity in its position
    could have believed that the alleged domestic dragnet was legal."
       -judge Vaughn R. Walker of the U.S. District Court
        for the Northern District of California, EFF vs. AT&T

