From: Jacob Schmidt Madsen <jacob@mungo.dk>
Subject: Re: Trouble when growing a raid5 array
Date: Fri, 1 Dec 2006 12:18:29 +0100
Message-ID: <200612011218.29088.jacob@mungo.dk>
References: <200611300804.15031.jacob@mungo.dk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200611300804.15031.jacob@mungo.dk>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hey again :-)

I'm starting to suspect that its a bug, since all I did was straight forward 
and it worked many times before.

When I try to stop the array by executing "mdadm -S /dev/md5", then mdadm 
stall (i'm suspecting it hit an error - maybe the same one).

I also tryed to restart the computer and made sure the array didnt auto-start. 
I then manually started it and the reshape process it shown when 
executing "cat /proc/mdstat", but it doesnt proceed (it seems stalled right 
away). When I try to stop it as shown above, it then stall mdadm like before.
So I'm able to reproduce the error.

I've tryed with kernel 2.6.18.3, 2.6.18.4 and 2.6.19 - with the same results 
as described above.

In case its a bug, then I would really like to help out, so its fixed and 
noone else will experience it (and I get my array fixed). What can I do to 
make sure its a bug and if it is, then what kind of information will be 
helpfull and where should I submit it?

I've checked the source code (raid5.c), but there's no comment included in the 
code, so I cant do much myself since my code experience with C is very small 
when it comes to kernel programming.

On Thursday 30 November 2006 08:04, Jacob Schmidt Madsen wrote:
> Hey
>
> I bought 2 new disks to be included in a big raid5 array.
>
> I executed:
> # mdadm /dev/md5 -a /dev/sdh1
> # mdadm /dev/md5 -a /dev/sdi1
> # mdadm --grow /dev/md5 --raid-disks=8
>
> After 12 hours it stalled:
> # cat /proc/mdstat
> md5 : active raid5 sdc1[6] sdb1[7] sdi1[3] sdh1[2] sdg1[1] sdf1[0] sde1[4]
> sdd1[5]
>       1562842880 blocks super 0.91 level 5, 64k chunk, algorithm 2 [8/8]
> [UUUUUUUU]
>       [===================>.]  reshape = 98.1% (306783360/312568576)
> finish=668.7min speed=144K/sec
>
> Its been stuck at 306783360/312568576 for hours now.
>
> When i check the kernel log it is full of "compute_blocknr: map not
> correct".
>
> I guess something went really bad? If someone know what is going on or if
> someone know what i can do to fix this.
> I would really be sad if all the data was gone.
>
> Thanks!
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
