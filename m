From: Oliver Schinagl <oliver+list@schinagl.nl>
Subject: Re: raid10 devices all marked as spares?!
Date: Tue, 29 May 2012 00:44:55 +0200
Message-ID: <4FC3FFE7.6020606@schinagl.nl>
References: <4FC3E4FB.4010003@schinagl.nl> <20120529080736.03c62ae1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120529080736.03c62ae1@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/29/12 00:07, NeilBrown wrote:
> On Mon, 28 May 2012 22:50:03 +0200 Oliver Schinagl<oliver+list@schinagl.nl>
> wrote:
>
>> Hi list,
>>
>> I'm sorry if this is the wrong place to start, but I've been quite lost
>> as to what is going wrong here.
>
> No, you are in exactly the right place!
Pfew :D

>
>>
>> I've been having some issues latly with my raid10 array. First some info.
>>
>> I have three raid10 arrays on my gentoo box on 2 drives using GPT.
>> I was running 3.2.1 at the time but have 3.4.0 running at the moment.
>> mdadm - v3.2.5 - 18th May 2012
>>
>>
>> md0, a 2 far-copies, 1.2 metadata, raid10 array  consisting of /dev/sda4
>> and sdb4.
>> md1, a 2 offset-copies, 1.2 metadata, raid10 array consisting of
>> /dev/sda5 and sdb5
>> md2, a 2 offset-copies, 1.2 metadata, raid10 array consisting of
>> /dev/sda6 and sdb6
>
> I'm liking the level of detail you are providing - thanks.
The more information provided, the better I always recon!

>
>>
>> sd*1 is bios_grub data, sd*2 is 256mb fat for playing with uefi and sd*3
>> is 8gigs of unused space, may have some version of ubuntu on it and sd*7
>> for swap.
>>
>> For all of this, md0 has always worked normally. it is being assembled
>> from initramfs where a static mdadm lives as such:
>> /bin/mdadm -A /dev/md0 -R -a md /dev/sda4 /dev/sdb4 || exit 1
>
> In general I wouldn't recommend this.  Names of sd devices change when
> devices are removed or added, so this is fragile.  It may cause the actual
> problems you have been experiencing currently.
Yes! Yes yes yes! I know. Kinda offtopic here, but:

I've always used a small 100mb -250mb (or 1gb on my desktop) array using 
metadata 0.9 and autodetect. This worked perfectly. /usr, /home etc 
where on exotic raid setups (metadata 1.2 etc) but this all just worked 
(tm).

Recently Fedora decided booting and /usr was a mess and not long after 
udev (i belive not only in gentoo) 'agreed' that /usr and / should be 
merged.

With 0.90 autodetect being depreciated by the kernel anyway I decided to 
bite the bullit and use my 8gb /usr as combined / and /usr. Now however 
I was 'forced' to also use an initramfs to get my raid array going. Long 
story short, I just quickly hacked that together as minimally as 
possible, as I haven't found any 'clean' way to do 
it/documented/recommended way to copy.

It's not only just error-prone, It's also broken. Having a disk missing 
or fail, causes kernel panics due to init pre-maturly failing because 
mdadm fails at finding /dev/sdb.

>
>>
>> md1 and md2 are being brought up during boot, md0 holds root, /usr etc
>> wheras md1 are just for home and data.
>>
>> The last few weeks md1 and md2 randomly fail to come up properly. md1 or
>> md2 come up as inactive and one of the two drivers are marked as spares.
>> (Why as spares? Why won't it try to run the array with a missing drive?)
>> While this happens, it's completly abitrary whether sda or sdb is being
>> used. so md1 can be sda5[2](S) and md2 can be sdb5[2](S).
>
> The (S) is a bit misleading here.  When an array is 'inactive', all devices
> are marked as '(S)', because they are not currently active (nothing is as the
> whole array is inactive).
>
> When md1 has sda5[2](S), is sdb5 mentioned for md1 as well, or is it simply
> absent.   I'm guessing the second.
Yes, i'm 99% sure however it's randomly sda6 or sdb6 that's shown. But 
never both. Only if I do mdadm -A /dev/md2 /dev/sda6 /dev/sdb6 (after 
stopping md2 first of course).

>
> This it most likely caused by "mdadm -I" being run by udev on device
> discovery.  Possibly it is racing with an "mdadm -A" run from a boot script.
> Have a look for a udev/rules.d script which run mdadm -I and maybe disable it
> and see what happens.
In init.d I find two scripts calling mdadm. /etc/init.d/mdadm only does 
monitoring (mdadm --monitor --scan --daemonize) I strongly doubt that 
forces any of the assembling? (even though scan is there?)

/etc/init.d/mdraid does some md stuff, but that's not run nor enabled.

BTW, I only start md0 from initramfs, so udev apparently does the rest 
(and sucks at it?)

>
>>
>> When this happens, I mdadm --stop /dev/md1 and /dev/md2, followed
>> immediatly by mdadm -A /dev/md1 (using mdadm.conf which doesn't even
>> list the devices. ARRAY /dev/md1 metadata=1.2 UUID=nnn name=host:home).
>> The arrays come up and work just fine.
>>
>> What happend today however, is that md2 again does not come up, and
>> sda6[3](S) shows in /proc/mdadm. However re-assembly of the array fails
>> and only using mdadm -A /dev/md2 /dev/sda6 /dev/sdb6 shows:
>> mdadm: device 1 in /dev/md2 has wrong state in superblock, but /dev/sdb6
>> seems ok
>> mdadm: /dev/md2 assembled from 0 drives and 2 spares - not enough to
>> start the array.
>> /proc/mdadm shows as somewhat expected.
>> md2 : inactive sda6[3](S) sdb6[2](S)
>>
>> Only using sdb6 however also fails. I guess because it does not want to
>> use a spare.
>> mdadm: failed to RUN_ARRAY /dev/md2: Invalid argument
>> mdadm: Not enough devices to start the array.
>>
>> Now the really disturbing part comes from mdadm --examine.
>> valexia oliver # mdadm --examine /dev/sda6
>> /dev/sda6:
>>             Magic : a92b4efc
>>           Version : 1.2
>>       Feature Map : 0x0
>>        Array UUID : nnnn
>>              Name : host:opt  (local to host host)
>>     Creation Time : Sun Aug 28 17:46:27 2011
>>        Raid Level : -unknown-
>>      Raid Devices : 0
>>
>>    Avail Dev Size : 456165376 (217.52 GiB 233.56 GB)
>>       Data Offset : 2048 sectors
>>      Super Offset : 8 sectors
>>             State : active
>>       Device UUID : nnnn
>>
>>       Update Time : Mon May 28 20:52:35 2012
>>          Checksum : ac17255 - correct
>>            Events : 1
>>
>>
>>      Device Role : spare
>>      Array State :  ('A' == active, '.' == missing)
>>
>> sdb6 lists identical content only with the checksum's being correbt,
>> albeit different and of coruse the Device UUID. Array UUID is of course
>> identical as is creation time.
>>
>> Also to note, is that grub2 does mention an 'error: Unsupported RAID
>> level: -1000000.' which probably relates to the 'Raid Level: -unknown-'.
>>
>> As to what may have caused this? I have absolutely no idea. I did a
>> clean shutdown where the arrays get cleanly unmounted. Not 100% sure if
>> the arrays get --stopped but I would be surprised if they did not.
>>
>> So I guess is this a md driver bug? Is there anything I can do to
>> recover my data, which i cannot image it not being?
>
> This is a known bug which has been fixed.  You are now running 3.4 so are
> safe from it.
Well this strange behavior all stemmed from running 3.2.1. I've only 
upgraded to 3.4 to see if that 'fixes' it. (It didn't :( unfortunately).

The -100000 error I'm assuming for now also stems from the meta data 
being corrupt, and will probably go away when trying the below tomorrow :)

> You can recover your data by re-creating the array.
>
>    mdadm -C /dev/md2 -l10 -n2 --layout o2 --assume-clean \
>    -e 1.2  /dev/sda6 /dev/sdb6
>
> Check that I have that right - don't just assume :-)
That looks very similar to what I used to create the array with, except 
the assume-clean part. I wonder however, would it not wiser to create 
the array using /dev/sda6 missing thus creating a degraded array? 
Atleast I'll still have the sdb6 which MAY contain the data also (since 
only sda6 'apparently' has wrong state?

Also, would it not be possible to mount sdb6 using the correct offset? I 
remember raid1 array's could simply be mounted. (with a 2 disk raid10, 
from what I understand, atleast 1 disk may be mountable?)

>
> when you have created the array, check that the 'Data Offset' is still
> correct, then if it is "fsck -n" the array to ensure everything looks good.
> Then you should be back in business.
I should then be able to compare it to md1/sda5 and /dev/sdb5. Since md1 
and md2 where created with identical settings, they should be almost the 
same when comparing :)


So to summarize, my array went foobar due to an old known bug and the 
only way to fix it is to recreate the array, leaving the actual data in 
place. The FS _should_ start after 2048 sectors on the disk.

>
> NeilBrown
>
>
>
>>
>> Thanks in advance for reading this.
>>
>> Oliver
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thank you so far for your help!
Oliver
