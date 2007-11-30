From: Bryce <bryce@zeniv.linux.org.uk>
Subject: Re: assemble vs create an array.......
Date: Fri, 30 Nov 2007 14:53:58 +0000
Message-ID: <47502406.8080809@zeniv.linux.org.uk>
References: <474F869D.5040503@mpigani.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <474F869D.5040503@mpigani.org>
Sender: linux-raid-owner@vger.kernel.org
To: Dragos <dragos@mpigani.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dragos wrote:
> Hello,
> I had created a raid 5 array on 3 232GB SATA drives. I had created one 
> partition (for /home) formatted with either xfs or reiserfs (I do not 
> recall).
> Last week I reinstalled my box from scratch with Ubuntu 7.10, with 
> mdadm v. 2.6.2-1ubuntu2.
> Then I made a rookie mistake: I --create instead of --assemble. The 
> recovery completed. I then stopped the array, realizing the mistake.
>
> 1. Please make the warning more descriptive: ALL DATA WILL BE LOST, 
> when attempting to created an array over an existing one.
> 2. Do you know of any way to recover from this mistake? Or at least 
> what filesystem it was formated with.
>
> Any help would be greatly appreciated. I have hundreds of family 
> digital pictures and videos that are irreplaceable.
> Thank you in advance,
> Dragos
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Meh,...
I do that all the time for testing
The raid metadata is separate from the FS in that you can trash it as 
much as you like and the FS it refers to will be fine as long as you 
don't decide to mkfs over it
If you've an old /var/log/messages kicking around from when the raid was 
correct you should be able to extract the order eg,

RAID5 conf printout:
 --- rd:5 wd:5
 disk 0, o:1, dev:sdf1
 disk 1, o:1, dev:sde1
 disk 2, o:1, dev:sdg1
 disk 3, o:1, dev:sdc1
 disk 4, o:1, dev:sdd1

Unfortunately, there is no point looking at mdadm -E <participating 
disk> as you've already trashed the information there
Anyway From the above the recreation of the array would be

mdadm -C -l5 -n5 -c128  /dev/md0 /dev/sdf1 /dev/sde1 /dev/sdg1 /dev/sdc1 
/dev/sdd1
(where -l5 = raid 5, -n5 = number of participating drives and -c128 = 
chunk size of 128K)

IF you don't have the configuration printout, then you're left with 
exhaustive brute force searching of the combinations
disks. Unfortunately possible combinations increase geometrically and 
going beyond 8 disks is a suicidally *bad* idea

2=2
3=6
4=24
5=120
6=720
7=5040
8=40320

You only have 3 drives so only 6 possible combinations to try (unlike 
myself with 5)

So, just write yourself a small script with all 6 combinations and run 
them through a piece of shell similar to this pseudo script

lvchange -an /dev/VolGroup01/LogVol00 # if you use lvm at all (change as 
appropriate or discard)
mdadm --stop --scan
yes | mdadm -C -l5 -n3 /dev/md0  /dev/sdd1 /dev/sde1 /dev/sdf1 # 
(replaceable combinations)
lvchange -ay  /dev/VolGroup01/LogVol00 # if you use lvm (or discard)
mount /dev/md0 /mnt
# Lets use the success return code for mount to indicate we're able to 
mount the FS again and bail out (man mount)
if [ $? eq 0 ] ; then
     exit 0
fi



