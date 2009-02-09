From: Max Waterman <davidmaxwaterman@fastmail.co.uk>
Subject: Re: Any hope for a 27 disk RAID6+1HS array with four disks reporting
 "No md superblock detected"?
Date: Mon, 09 Feb 2009 13:47:23 +0200
Message-ID: <499017CB.30307@fastmail.co.uk>
References: <1233775657.10151.5.camel@localhost.localdomain> <18827.51024.270348.20624@notabene.brown> <alpine.LNX.2.00.0902061903510.21732@filesrv1.baby-dragons.com> <9B27D278-ED85-498A-8EF6-DDB7EFB103F7@unh.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9B27D278-ED85-498A-8EF6-DDB7EFB103F7@unh.edu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thomas Baker wrote:
>
> On Feb 6, 2009, at 11:05 PM, Mr. James W. Laferriere wrote:
>
>>     Hello Neil ,  In this thread you mention a (I think) script named 
>> examinRAIDDisks .
>>     Is this available someplace ?
>>     I've searched the archive & it does not appear to be mentioned 
>> anywhere but this thread .
>>         Tia ,  JimL
>
> It's just a script I wrote that runs mdadm -E on all my disks so I 
> don't have to keep typing all those disk names:
>
> #!/bin/csh -x
>
> mdadm -E \
> /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 \
> /dev/sdi1 /dev/sdj1 /dev/sdk1 /dev/sdl1 /dev/sdm1 /dev/sdn1 /dev/sdo1 \
> /dev/sdp1 /dev/sdq1 /dev/sdr1 /dev/sds1 /dev/sdt1 /dev/sdu1 /dev/sdv1 \
> /dev/sdw1 /dev/sdx1 /dev/sdy1 /dev/sdz1 /dev/sdaa1 /dev/sdab1 /dev/sdac1
I'm sure most people know this (and I already replied privately), but I 
just love these features of 'the' (most) shell, so I figured I'd share...

I'd guess these produce identical arg lists :

The shell will expand the args, match them to files, and complain if one 
doesn't exist...

$ echo /dev/sd[b-z]1 /dev/sba[a-c]1

The shell will just expand the args, not checking if a file exists with 
the same name :

$ echo /dev/sd{b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,aa,ab,ac}1
/dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1 /dev/sdh1 
/dev/sdi1 /dev/sdj1 /dev/sdk1 /dev/sdl1 /dev/sdm1 /dev/sdn1 /dev/sdo1 
/dev/sdp1 /dev/sdq1 /dev/sdr1 /dev/sds1 /dev/sdt1 /dev/sdu1 /dev/sdv1 
/dev/sdw1 /dev/sdx1 /dev/sdy1 /dev/sdz1 /dev/sdaa1 /dev/sdab1 /dev/sdac1

ie, this will also work :

$ echo max was {here,there,everywhere}

irrespective of any files that may or may not exist;
...but this might be a surprise :

$ echo /dev/sd[abcd]1
/dev/sda1
$ echo /dev/sd[bcd]1
/dev/sd[bcd]1

I only have the one drive (sda) on this computer, so 'sa[abcd]1' only 
matched one drive. The unexpected bit is that the shell passed on the 
arg 'as is' when it didn't match any file (IIRC that's different for 
csh, which I notice you're using).

As ever, YMMV.

Max.

