From: sylarrrrrrr@aim.com
Subject: Re: How to load preexisting ntfs partitions that are on an Intel Matrix
 Raid 1 or 5 ?
Date: Sat, 16 Jan 2010 08:57:03 -0500
Message-ID: <8CC64CAEA9C15A3-938C-10EBD@webmail-m048.sysops.aol.com>
References: <8CC636345AA2F7E-295C-545@webmail-d049.sysops.aol.com> <8CC636C98CCAF21-295C-17C7@webmail-d049.sysops.aol.com> <20100116090848.GA21855@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100116090848.GA21855@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: bluca@comedia.it, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

OK So this is the mdadm mailing list, and the /dev/mapper is irrelevant 
here, right? So ...

How do I load my existing raid arrays with mdadm?


-----Original Message-----
From: Luca Berra <bluca@comedia.it>
To: linux-raid@vger.kernel.org
Cc: ataraid-list@redhat.com
Sent: Sat, Jan 16, 2010 11:08 am
Subject: Re: How to load preexisting ntfs partitions that are on an 
Intel Matrix Raid 1 or 5 ?


On Thu, Jan 14, 2010 at 03:09:22PM -0500, sylarrrrrrr@aim.com wrote:
>  How to load preexisting ntfs partitions that are on an Intel Matrix 
Raid 1 > or 5 ?

either with md or dmraid + ntfs-3g

> I must also know that the loading of the partitions in linux will not 
> damage them.
> Is the Intel Matrix Raid feature safe ?
which one?
dmraid i have no info, just tried it once,
mdadm: check the archives of this list
3.0.2 is broken
3.0.3 fixes some bugs
many more bug fixes are in git and will be in 3.1.2 i believe.

> I tried with the latest Knoppix 6.2 LiveCD, but the device was not > 
seenautomatically,  in /dev/mapper I found too many entries, which made 
> mesuspicious that my raids are not recognized well.

/dev/mapper is dmraid not mdadm,
besides that what do you mean with two many?
show evidence (dmsetup ls, dmraid -c, etc)
and maybe send it to ataraid-list@redhat.com, which deals with dmraid
> Packages versions in my Knoppix:
>
> ii  mdadm                                  3.0.3-2                    
      >  tool to administer Linux MD arrays (software
>
> ii  linux-image-2.6.31.6                   2.6.31.6-10.00.Custom      
      >  Linux kernel binary image for version 2.6.31
>
>
>

-- Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" 
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
==================================================

PS. I am not next to that machine right now, but I have 3 raid devices 
on it and in the /dev/mapper there were about 6 or 8 devices some of 
which had similar names and consecutive numbers e.g. 
xxxxxxxxxxxxx_System1 xxxxxxxxxxxxx_System2 xxxxxxxxxxxxx_System3 while 
my partition on one of the raid devices was called System and was raid 
1 of two disks.
  
