From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Adding a new drive to an array
Date: Sun, 22 Jun 2014 19:33:57 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1406221931230.18361@uplift.swm.pp.se>
References: <CAG__1a6i-UsOJpy+5GdwV_a-cVDCi_F_5KztwkFbNUEONDhH5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAG__1a6i-UsOJpy+5GdwV_a-cVDCi_F_5KztwkFbNUEONDhH5w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Duffield <forumscollective@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, 22 Jun 2014, George Duffield wrote:

> I've got a RAID5 array comprised of 4 x 3TB drives which is 97% full
> and would like to grow the array by adding a 5th drive of the same
> make/ model.

Consider adding two drives and go to RAID6.

http://www.zdnet.com/blog/storage/why-raid-5-stops-working-in-2009/162

> Looking at https://raid.wiki.kernel.org/index.php/Growing it seems the
> approach (after partitioning the drive) is to:
>
> 1) add the drive to the pool: # mdadm --add /dev/md127 /dev/sdX1
> 2) grow the array: # mdadm --grow --raid-devices=5
> --backup-file=~/grow_md127.backup  /dev/md127

Make sure the backup file is NOT on a filesystem that is on the md being 
resized. Put it on /root or something instead.

> 3) edit mdadm.conf to include the 5th drive i.e. num-devices=5
> 4) determine raid stride size calculated with chunk / block
> 4) ensure the array is unmounted and resize ext4: # resize2fs -S
> ascertained_stride_size -p /dev/md127

Yeah, that looks about right. Don't know if you really need step 4, just 
enmount and resize, I would imagine that if you have a reasonable resent 
version of the tools it'll figure out the stride size automatically.

You cannot avoid the resync, so stop looking into weird options. The 
resizing will take days.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
