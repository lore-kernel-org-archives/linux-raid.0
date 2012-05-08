From: =?ISO-8859-1?Q?H=E1kon_G=EDslason?= <hakon.gislason@gmail.com>
Subject: Re: Failed drive while converting raid5 to raid6, then a hard reboot
Date: Tue, 8 May 2012 23:55:09 +0000
Message-ID: <CAFTzWnoEZdZDA6jwHzXmq84T_7eESim0=GW4wr=RgPuTAxYjzQ@mail.gmail.com>
References: <CAFTzWnrQARaemDkMNe48zT8tipPmsVbt0ZFgfDTyrtUc9KjuZQ@mail.gmail.com>
 <20120509064858.4e39c389@notabene.brown> <CAFTzWnrGf5Fs4wRekjnOHfutANArJiT8j-Y6Mbd+nxPXXXrnSA@mail.gmail.com>
 <20120509092109.0cae5c3c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120509092109.0cae5c3c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thank you very much!
It's currently rebuilding, I'll make an attempt to mount the volume
once it completes the build. But before that, I'm going to image all
the disks to my friends array, just to be safe. After that, backup
everything.
Again, thank you for your help!
--
H=E1kon G.


On 8 May 2012 23:21, NeilBrown <neilb@suse.de> wrote:
> On Tue, 8 May 2012 22:19:49 +0000 H=E1kon G=EDslason <hakon.gislason@=
gmail.com>
> wrote:
>
>> Thank you for the reply, Neil
>> I was using mdadm from the package manager in Debian stable first
>> (v3.1.4), but after the constant drive failures I upgraded to the
>> latest one (3.2.3).
>> I've come to the conclusion that the drives are either failing becau=
se
>> they are "green" drives, and might have power-saving features that a=
re
>> causing them to be "disconnected", or that the cables that came with
>> the motherboard aren't good enough. I'm not 100% sure about either,
>> but at the moment these seem likely causes. It could be incompatible
>> hardware or the kernel that I'm using (proxmox debian kernel:
>> 2.6.32-11-pve).
>>
>> I got the array assembled (thank you), but what about the raid5 to
>> raid6 conversion? Do I have to complete it for this to work, or will
>> mdadm know what to do? Can I cancel (revert) the conversion and get
>> the array back to raid5?
>>
>> /proc/mdstat contains:
>>
>> root@axiom:~# cat /proc/mdstat
>> Personalities : [raid6] [raid5] [raid4]
>> md0 : active (read-only) raid6 sdc[6] sdb[5] sda[4] sdd[7]
>> =A0 =A0 =A0 5860540224 blocks super 1.2 level 6, 32k chunk, algorith=
m 18 [5/3] [_UUU_]
>>
>> unused devices: <none>
>>
>> If I try to mount the volume group on the array the kernel panics, a=
nd
>> the system hangs. Is that related to the incomplete conversion?
>
> The array should be part way through the conversion. =A0If you
> =A0 mdadm -E /dev/sda
> it should report something like "Reshape Position : XXXX" indicating
> how far along it is.
> The reshape will not restart while the array is read-only. =A0Once yo=
u make it
> writeable it will automatically restart the reshape from where it is =
up to.
>
> The kernel panic is because the array is read-only and the filesystem=
 tries
> to write to it. =A0I think that is fixed in more recent kernels (i.e.=
 ext4
> refuses to mount rather than trying and crashing).
>
> So you should just be able to "mdadm --read-write /dev/md0" to make t=
he array
> writable, and then continue using it ... until another device fails.
>
> Reverting the reshape is not currently possible. =A0Maybe it will be =
with Linux
> 3.5 and mdadm-3.3, but that is all months away.
>
> I would recommend an "fsck -n /dev/md0" first and if that seems mostl=
y OK,
> and if "mdadm -E /dev/sda" reports the "Reshape Position" as expected=
, then
> make the array read-write, mount it, and backup any important data.
>
> NeilBrown
>
>
>>
>> Thanks,
>> --
>> H=E1kon G.
>>
>>
>>
>> On 8 May 2012 20:48, NeilBrown <neilb@suse.de> wrote:
>> >
>> > On Mon, 30 Apr 2012 13:59:56 +0000 H=E1kon G=EDslason
>> > <hakon.gislason@gmail.com>
>> > wrote:
>> >
>> > > Hello,
>> > > I've been having frequent drive "failures", as in, they are repo=
rted
>> > > failed/bad and mdadm sends me an email telling me things went wr=
ong,
>> > > etc... but after a reboot or two, they are perfectly fine again.=
 I'm
>> > > not sure what it is, but this server is quite new and I think th=
ere
>> > > might be more behind it, bad memory or the motherboard (I've bee=
n
>> > > having other issues as well). I've had 4 drive "failures" in thi=
s
>> > > month, all different drives except for one, which "failed" twice=
, and
>> > > all have been fixed with a reboot or rebuild (all drives reporte=
d bad
>> > > by mdadm passed an extensive SMART test).
>> > > Due to this, I decided to convert my raid5 array to a raid6 arra=
y
>> > > while I find the root cause of the problem.
>> > >
>> > > I started the conversion right after a drive failure & rebuild, =
but as
>> > > it had converted/reshaped aprox. 4%(if I remember correctly, and=
 it
>> > > was going really slowly, ~7500 minutes to completion), it report=
ed
>> > > another drive bad, and the conversion to raid6 stopped (it said
>> > > "rebuilding", but the speed was 0K/sec and the time left was a f=
ew
>> > > million minutes.
>> > > After that happened, I tried to stop the array and reboot the se=
rver,
>> > > as I had done previously to get the reportedly "bad" drive worki=
ng
>> > > again, but It=A0wouldn't=A0stop the array or reboot, neither cou=
ld I
>> > > unmount it, it just hung whenever I tried to do something with
>> > > /dev/md0. After trying to reboot a few times, I just killed the =
power
>> > > and re-started it.=A0Admittedly=A0this was probably not the best=
 thing I
>> > > could have done at that point.
>> > >
>> > > I have backup of ca. 80% of the data on there, it's been a month=
 since
>> > > the last complete backup (because I ran out of backup disk space=
).
>> > >
>> > > So, the big question, can the array be activated, and can it com=
plete
>> > > the conversion to raid6? And will I get my data back?
>> > > I hope the data can be rescued, and any help I can get would be =
much
>> > > appreciated!
>> > >
>> > > I'm fairly new to raid in general, and have been using mdadm for=
 about
>> > > a month now.
>> > > Here's some data:
>> > >
>> > > root@axiom:~# mdadm --examine --scan
>> > > ARRAY /dev/md/0 metadata=3D1.2 UUID=3Dcfedbfc1:feaee982:4e92ccf4=
:45e08ed1
>> > > name=3Daxiom.is:0
>> > >
>> > >
>> > > root@axiom:~# cat /proc/mdstat
>> > > Personalities : [raid6] [raid5] [raid4]
>> > > md0 : inactive sdc[6] sde[7] sdb[5] sda[4]
>> > > =A0 =A0 =A0 7814054240 blocks super 1.2
>> > >
>> > > root@axiom:~# mdadm --assemble --scan --force --run /dev/md0
>> > > mdadm: /dev/md0 is already in use.
>> > >
>> > > root@axiom:~# mdadm --stop /dev/md0
>> > > mdadm: stopped /dev/md0
>> > >
>> > > root@axiom:~# mdadm --assemble --scan --force --run /dev/md0
>> > > mdadm: Failed to restore critical section for reshape, sorry.
>> > > =A0 =A0 =A0 Possibly you needed to specify the --backup-file
>> > >
>> > > root@axiom:~# mdadm --assemble --scan --force --run /dev/md0
>> > > --backup-file=3D/root/mdadm-backup-file
>> > > mdadm: Failed to restore critical section for reshape, sorry.
>> >
>> > What version of mdadm are you using?
>> >
>> > I suggest getting a newer one (I'm about to release 3.2.4, but 3.2=
=2E3
>> > should
>> > be fine) and if just that doesn't help, add the "--invalid-backup"=
 option.
>> >
>> > However I very strongly suggest you try to resolve the problem whi=
ch is
>> > causing your drives to fail. =A0Until you resolve that it will kee=
p
>> > happening
>> > and having it happen repeatly during the (slow) reshape process wo=
uld not
>> > be
>> > good.
>> >
>> > Maybe plug the drives into another computer, or another controller=
, while
>> > the
>> > reshape runs?
>> >
>> > NeilBrown
>> >
>> >
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
