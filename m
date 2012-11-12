From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: question: no-bitmap RAID1 with off-site drive
Date: Mon, 12 Nov 2012 14:40:15 +1100
Message-ID: <50A06F9F.3090600@websitemanagers.com.au>
References: <6.2.5.6.2.20121111163935.05df8b18@binnacle.cx> <6.2.5.6.2.20121111170842.05dfe758@binnacle.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6.2.5.6.2.20121111170842.05dfe758@binnacle.cx>
Sender: linux-raid-owner@vger.kernel.org
To: starlight.2012q4@binnacle.cx
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/11/12 09:14, starlight.2012q4@binnacle.cx wrote:
> Would like to have the option to zero the
> superblock of an incoming drive and have
> it treated as a virgin replacement.
>
> I tried this (I think) by running
>
>    mdadm --add /dev/md2 /dev/sde
>
> It worked, but assigned the new drive
> as device number [2], which seems
> incorrect.  I tried failing/removing the
> drive followed by a
>
>    mdadm --remove /dev/md2 detached
>
> and repeated the --add with a zero-superblock
> drive but it does the same thing every time.
> Only way to get it to reuse drive slot 1
> was to do a 
>
>    mdadm --grow --raid-devices=1 --force /dev/md2
>
> followed by a
>
>    mdadm --grow --add --raid-devices=2 /dev/md2 /dev/sde
>
> Is this the expected behavior?  I find it
> confusing and probably don't understand
> it properly.
>
I think (from what I understand) is that you will do the following:
1) Two HDD in raid1 installed, synced, working
2) Install third HDD
3) mdadm --manage /dev/md2 --add /dev/sde (add it as a spare)
4) mdadm --grow /dev/md2 --raid-devices=3 (add the third disk to the
array, and let it sync)
5) madam --manage /dev/md2 --fail /dev/sdd (fail the disk you want to
remove)
6) mdadm --manage /dev/md2 --remove /dev/sdd (remove the disk from the
array)
7) mdadm --grow /dev/md2 --raid-devices=2 (reconfigure the array to only
have two disks)
8) Physically remove sdd and send offsite

The above process will ensure that you ALWAYS have at least two copies
of your live data (ie, two working, fully synced members of the array).

I have seen that there are some new features to make a drive as "want
replacement", which will do some magic to copy all the data to a spare
device without actually removing the drive until the spare is synced or
similar. However, I think this is only in very recent kernel, and you
might need to do some work in finding the usage details etc.

Hope the above helps.

Regards,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au

