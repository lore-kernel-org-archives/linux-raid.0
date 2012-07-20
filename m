From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: [RFE] Please, add optional RAID1 feature (= chunk checksums) to
 make it more robust
Date: Fri, 20 Jul 2012 17:21:27 -0300
Message-ID: <CABYL=Tp+ACU2qhfoa_-_VHU3siMNQjf+c1CfJ3=KFLFvPsmVuA@mail.gmail.com>
References: <CABYL=Tqc4D00Y9S5Ow5mzgqvGFtx6qh=XhQQUXzpcUuReNniyA@mail.gmail.com>
	<9a781621-01c9-4cc6-9bc1-3626dda0f835@zmail15.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9a781621-01c9-4cc6-9bc1-3626dda0f835@zmail15.collab.prod.int.phx2.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jaromir Capik <jcapik@redhat.com>
Cc: stan@hardwarefreak.com, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

yeah for a 'fast' solution moving from one file system to another that
works with theses checks can help you, while we check if this is
usefull or not

IMHO, if we implement this, we should implement outside any today raid
levels, this should be done between device and filesystem, in others
words:

we should implement this to work like:
DISKS - (OUR NEW SILENT ERROR SECURITY SYSTEM LEVEL, 1 PER DEVICE) -
TODAY RAID LEVELS - FILESYSTEMS

or

DISKS - RAIDS LEVELS - (OUR NEW SILENT ERROR SECURITY SYSTEM LEVEL, 1
PER DEVICE) - FILESYSTEM

or

DISK - (OUR NEW SILENT ERROR SECURITY SYSTEM LEVEL, 1 PER DEVICE) - FILESYSTEM


using this, we "could give more security" to usb pendrives for
example, and any block device (network block device, DRBD, or anyother
block device in linux)


2012/7/20 Jaromir Capik <jcapik@redhat.com>:
>> it's not normal to lost data but it's possible (electronic problems,
>> radioactive problems or another problem not related maybe lost of disk
>> magnetic properties)
>
> It might be also caused by a bug in the SATA controller driver.
> And nobody can be sure that there will be no new issues in case
> of future chipsets and their very first driver versions.
>
>
>> since we are at block device layer (md) i don't know if we
>> could/should implement a recovery algorithm or just a badblock report
>> algorithm (checksum)
>
> Direct recovery would be better since it doesn't cost much and lowers
> the possibility of data loss due to the second drive's failure.
>
>
>> maybe for a 'fast' solution you could use raid5 or raid6? while we
>> discuss if this could/should/will not be implemented?!
>> i think raid5/6 have checksums and others tools to get this type of
>> problem while you can use your normal filesystem (ext3? ext4? reiser?
>> xfs?) or direct the block device (a oracle database for example or
>> mysql innodb)
>
> RAID5/6 would need more drives than I actually have, right? There's
> not enough space for 3 drives in those small and cheap mini-ITX based home
> routers/servers I started building 3 years ago. Moreover that would mean
> a need for better cooling and a higher power consumption and that's
> something I'm exactly trying to avoid in this particular case.
>
> I slowly started to accept the idea, that I'll have to migrate my
> systems from mdraid to btrfs if there's no solution soon :( I don't
> like it much, but there's apparently nothing else I can do about that.
>
>> --
>> Roberto Spadim
>> Spadim Technology / SPAEmpresarial
>>
>
> Thanks a lot for your answers and have a nice day.
>
> Regards,
> Jaromir.
>
> --
> Jaromir Capik
> Red Hat Czech, s.r.o.
> Software Engineer / BaseOS
>
> Email: jcapik@redhat.com
> Web: www.cz.redhat.com
> Red Hat Czech s.r.o., Purkynova 99/71, 612 45, Brno, Czech Republic
> IC: 27690016
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Roberto Spadim
Spadim Technology / SPAEmpresarial
