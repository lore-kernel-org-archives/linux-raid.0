From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: Re: RAID-10 keeps aborting
Date: Wed, 05 Jun 2013 12:02:55 +0200
Message-ID: <51AF0CCF.8000909@itwm.fraunhofer.de>
References: <51AC1440.7020505@zytor.com> <CAA9_cmddLfReYeAhgwh5=j6ELMBNx5Oq7Gg8K+fo0PneaEfrVA@mail.gmail.com> <51AC3283.4000403@zytor.com> <CAA9_cme6tYpYnrZDbrDduwPCjVn+PFbx_rZNPFazBEU9EF0upw@mail.gmail.com> <51ACBAA0.40604@zytor.com> <CAA9_cmc3Gs91C4aV6okUw-=q+fACm1+dooyafOZi+Lnj+Ne_ig@mail.gmail.com> <51ACD511.4030604@zytor.com> <yq1y5art543.fsf@sermon.lab.mkp.net> <51AD2485.9000601@zytor.com> <alpine.DEB.2.02.1306041132260.19072@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1306041132260.19072@jlaw-desktop.mno.stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Dan Williams <dan.j.williams@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/04/2013 05:39 PM, Joe Lawrence wrote:
>
> Just curious, what type drives were in your RAID and what does
> /sys/class/scsi_disk/*/max_write_same_blocks report?  If you have a spare
> drive to test, maybe you could try a quick sg_write_same command to see
> how the drive reacts?
>

I just run into the same issue with an ancient system from 2006. Except 
that I'm in hurry an need it to stress-test my own work, I can do 
anything with it - it is booted via NFS and disks are only used for 
development/testing.

> (squeeze)fslab1:~# cat /sys/block/md126/queue/write_same_max_bytes
> 16384

> (squeeze)fslab1:~# cat /sys/block/sd[o,n,m,l]/queue/write_same_max_bytes
> 0
> 0
> 0
> 0


Ah, now I found the reason why it fails, scsi-layer had set 
write_same_max_bytes to zero when it detected that it does not support 
it, but after reloading the arecal module (arcmsr) I now get:

> (squeeze)fslab1:~# cat /sys/block/sd[o,n,m,l]/queue/write_same_max_bytes
> 33553920
> 33553920
> 33553920
> 33553920

Now for example

> 11:0:1:2]   disk    Hitachi  HDS724040KLSA80  R001  /dev/sdl  /dev/sg11

> (squeeze)fslab1:~# sg_write_same --num=100 /dev/sg11
> Write same(10) command not supported


> (squeeze)fslab1:~# sg_write_same --16 --num=100 /dev/sg11
> Write same(16) command not supported


Cheers,
Bernd


PS: This is the 2nd time this I run into this, on Sunday I had a similar 
same issue at home with Ubuntus 3.8 kernel, but somehow not with vanilla 
3.9. I need to recheck the logs in evening to see if it is really the 
same issue.




