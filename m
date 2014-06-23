From: George Duffield <forumscollective@gmail.com>
Subject: Fwd: Adding a new drive to an array
Date: Mon, 23 Jun 2014 16:47:07 +0200
Message-ID: <CAG__1a5M8RKfk1en3j8Cz9hBsPtB+g=znbzOE3hYOZZ2ZgU++g@mail.gmail.com>
References: <CAG__1a6i-UsOJpy+5GdwV_a-cVDCi_F_5KztwkFbNUEONDhH5w@mail.gmail.com>
	<alpine.DEB.2.02.1406221931230.18361@uplift.swm.pp.se>
	<CAG__1a4EG1PNpy_3Zt23OuEaEn1jTsF3-0-o21EQJBRCTPVORg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAG__1a4EG1PNpy_3Zt23OuEaEn1jTsF3-0-o21EQJBRCTPVORg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Consider adding two drives and go to RAID6.
>
> http://www.zdnet.com/blog/storage/why-raid-5-stops-working-in-2009/162

Isn't what you're really saying then is that it's best to abandon RAID
altogether when dealing with large storage requirements utilising high
capacity drives?  Filling each drive individually and backing it up to
another drive presumably involves a lot less iro r/w operations and if
one fails you simply replace it with another of the same or larger
size and be done with it.  Just make sure you have current backups
(which you need to have even if using RAID).  The only real downside
then is the inability to deal with the storage as a consolidated whole
(I'm guessing LVM would be just as problematic as RAID if a drive in a
volume fails)?

>> Looking at https://raid.wiki.kernel.org/index.php/Growing it seems the
>> approach (after partitioning the drive) is to:
>>
>> 1) add the drive to the pool: # mdadm --add /dev/md127 /dev/sdX1
>> 2) grow the array: # mdadm --grow --raid-devices=5
>> --backup-file=~/grow_md127.backup  /dev/md127
>
>
> Make sure the backup file is NOT on a filesystem that is on the md being
> resized. Put it on /root or something instead.
>
>
>> 3) edit mdadm.conf to include the 5th drive i.e. num-devices=5
>> 4) determine raid stride size calculated with chunk / block
>> 4) ensure the array is unmounted and resize ext4: # resize2fs -S
>> ascertained_stride_size -p /dev/md127
>
>
> Yeah, that looks about right. Don't know if you really need step 4, just
> enmount and resize, I would imagine that if you have a reasonable resent
> version of the tools it'll figure out the stride size automatically.
>
> You cannot avoid the resync, so stop looking into weird options. The
> resizing will take days.
>

What are weird options for if not to be used ;-)

What is the purpose of --assume-clean then when man states:
When  an  array  is resized to a larger size with --grow --size= the
new space is normally resynced in that  same  way  that  the whole
array  is  resynced at creation.  From Linux version 3.0,
--assume-clean can be used with that command to avoid the  automatic
resync.

^^^ What is the automatic resync being referred to in man?
