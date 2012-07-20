From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: [RFE] Please, add optional RAID1 feature (= chunk checksums) to
 make it more robust
Date: Fri, 20 Jul 2012 17:59:51 -0300
Message-ID: <CABYL=TqSaT0Y-wnfMwwe9v2tsOV_kuVh1b3FTPp82Q7KQe-6OQ@mail.gmail.com>
References: <CABYL=Tp+ACU2qhfoa_-_VHU3siMNQjf+c1CfJ3=KFLFvPsmVuA@mail.gmail.com>
	<2a2061ca-29d1-4397-9eed-a4f4941090a4@zmail15.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2a2061ca-29d1-4397-9eed-a4f4941090a4@zmail15.collab.prod.int.phx2.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jaromir Capik <jcapik@redhat.com>
Cc: stan@hardwarefreak.com, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

sorry about many posts guys (that=B4s not a spam)

well... we are discussing ideas...

IMO, that's one more layer (ok some developers like it, some
developers don't), this implement a security layer of some well know
harddrives, like ECC, checksums (maybe we will talk about inteligent
SDD reallocation algorithm too...)
since we are near to emulate a harddisk controller (with more tools)
we could report block errors too like a harddisk do
the error correction could be done by some raid levels that implement
block correction (resync or maybe badblock reallocation)...
just ideas... it's hard to implement and must be well tested... like
any new code

2012/7/20 Jaromir Capik <jcapik@redhat.com>:
>> yeah for a 'fast' solution moving from one file system to another
>> that
>> works with theses checks can help you, while we check if this is
>> usefull or not
>>
>> IMHO, if we implement this, we should implement outside any today
>> raid
>> levels, this should be done between device and filesystem, in others
>> words:
>>
>> we should implement this to work like:
>> DISKS - (OUR NEW SILENT ERROR SECURITY SYSTEM LEVEL, 1 PER DEVICE) -
>> TODAY RAID LEVELS - FILESYSTEMS
>>
>> or
>>
>> DISKS - RAIDS LEVELS - (OUR NEW SILENT ERROR SECURITY SYSTEM LEVEL, =
1
>> PER DEVICE) - FILESYSTEM
>>
>> or
>>
>> DISK - (OUR NEW SILENT ERROR SECURITY SYSTEM LEVEL, 1 PER DEVICE) -
>> FILESYSTEM
>>
>>
>> using this, we "could give more security" to usb pendrives for
>> example, and any block device (network block device, DRBD, or
>> anyother
>> block device in linux)
>
> Well ... it looks more modular, easier and could have more usecases.
> You're probably right at this point. Dracut maintainers would kill
> us both, but that's a different story.
> I'm only missing that possibility of immediate resyncing of the data
> when a corruption is detected. That's probably the only thing, that
> would be nice to have directly in the RAID layer (and could/should
> be also optional).
>
> J.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
