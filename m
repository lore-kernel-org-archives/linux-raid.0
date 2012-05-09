From: =?ISO-8859-1?Q?H=E1kon_G=EDslason?= <hakon.gislason@gmail.com>
Subject: Re: Failed drive while converting raid5 to raid6, then a hard reboot
Date: Wed, 9 May 2012 00:46:15 +0000
Message-ID: <CAFTzWnrFZf0N6KdJkgtkXmTt7JjWPhCOWR0AbJiS=CWznPgtmg@mail.gmail.com>
References: <CAFTzWnrQARaemDkMNe48zT8tipPmsVbt0ZFgfDTyrtUc9KjuZQ@mail.gmail.com>
 <20120509064858.4e39c389@notabene.brown> <CAFTzWnrGf5Fs4wRekjnOHfutANArJiT8j-Y6Mbd+nxPXXXrnSA@mail.gmail.com>
 <20120509092109.0cae5c3c@notabene.brown> <CAFTzWnoEZdZDA6jwHzXmq84T_7eESim0=GW4wr=RgPuTAxYjzQ@mail.gmail.com>
 <CAFTzWnqdTt92RWjSr8Ve_oOWBUphw5DFTGY3Xn4AkawN-0YBpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFTzWnqdTt92RWjSr8Ve_oOWBUphw5DFTGY3Xn4AkawN-0YBpA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Nevermind, got it back up and running using --force.
Stopping the array, halting the server, going to image all the disks fi=
rst.
--
H=E1kon G.


On 9 May 2012 00:20, H=E1kon G=EDslason <hakon.gislason@gmail.com> wrot=
e:
> Hi again, I thought the drives would last long enough to complete the
> reshape, I assembled the array, it started reshaping, went for a
> shower, and came back to this: http://pastebin.ubuntu.com/976993/
>
> The logs show the same as when the other drives failed:
> May =A08 23:58:26 axiom kernel: ata4: hard resetting link
> May =A08 23:58:32 axiom kernel: ata4: link is slow to respond, please=
 be
> patient (ready=3D0)
> May =A08 23:58:37 axiom kernel: ata4: hard resetting link
> May =A08 23:58:42 axiom kernel: ata4: link is slow to respond, please=
 be
> patient (ready=3D0)
> May =A08 23:58:47 axiom kernel: ata4: hard resetting link
> May =A08 23:58:52 axiom kernel: ata4: link is slow to respond, please=
 be
> patient (ready=3D0)
> May =A08 23:59:22 axiom kernel: ata4: limiting SATA link speed to 1.5=
 Gbps
> May =A08 23:59:22 axiom kernel: ata4: hard resetting link
> May =A08 23:59:27 axiom kernel: ata4.00: disabled
> May =A08 23:59:27 axiom kernel: ata4: EH complete
> May =A08 23:59:27 axiom kernel: sd 3:0:0:0: [sdd] Unhandled error cod=
e
> May =A08 23:59:27 axiom kernel: sd 3:0:0:0: [sdd] Result:
> hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
> May =A08 23:59:27 axiom kernel: sd 3:0:0:0: [sdd] CDB: Write(10): 2a =
00
> 00 00 00 08 00 00 02 00
> May =A08 23:59:27 axiom kernel: md: super_written gets error=3D-5, up=
todate=3D0
> May =A08 23:59:27 axiom kernel: sd 3:0:0:0: [sdd] Unhandled error cod=
e
> May =A08 23:59:27 axiom kernel: sd 3:0:0:0: [sdd] Result:
> hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
> May =A08 23:59:27 axiom kernel: sd 3:0:0:0: [sdd] CDB: Read(10): 28 0=
0
> 0a 9d cb 00 00 00 40 00
> May =A08 23:59:27 axiom kernel: md: md0: reshape done.
>
> What course of action do you suggest I take now?
>
> --
> H=E1kon G.
>
>
> On 8 May 2012 23:55, H=E1kon G=EDslason <hakon.gislason@gmail.com> wr=
ote:
>> Thank you very much!
>> It's currently rebuilding, I'll make an attempt to mount the volume
>> once it completes the build. But before that, I'm going to image all
>> the disks to my friends array, just to be safe. After that, backup
>> everything.
>> Again, thank you for your help!
>> --
>> H=E1kon G.
>>
>>
>> On 8 May 2012 23:21, NeilBrown <neilb@suse.de> wrote:
>>> On Tue, 8 May 2012 22:19:49 +0000 H=E1kon G=EDslason <hakon.gislaso=
n@gmail.com>
>>> wrote:
>>>
>>>> Thank you for the reply, Neil
>>>> I was using mdadm from the package manager in Debian stable first
>>>> (v3.1.4), but after the constant drive failures I upgraded to the
>>>> latest one (3.2.3).
>>>> I've come to the conclusion that the drives are either failing bec=
ause
>>>> they are "green" drives, and might have power-saving features that=
 are
>>>> causing them to be "disconnected", or that the cables that came wi=
th
>>>> the motherboard aren't good enough. I'm not 100% sure about either=
,
>>>> but at the moment these seem likely causes. It could be incompatib=
le
>>>> hardware or the kernel that I'm using (proxmox debian kernel:
>>>> 2.6.32-11-pve).
>>>>
>>>> I got the array assembled (thank you), but what about the raid5 to
>>>> raid6 conversion? Do I have to complete it for this to work, or wi=
ll
>>>> mdadm know what to do? Can I cancel (revert) the conversion and ge=
t
>>>> the array back to raid5?
>>>>
>>>> /proc/mdstat contains:
>>>>
>>>> root@axiom:~# cat /proc/mdstat
>>>> Personalities : [raid6] [raid5] [raid4]
>>>> md0 : active (read-only) raid6 sdc[6] sdb[5] sda[4] sdd[7]
>>>> =A0 =A0 =A0 5860540224 blocks super 1.2 level 6, 32k chunk, algori=
thm 18 [5/3] [_UUU_]
>>>>
>>>> unused devices: <none>
>>>>
>>>> If I try to mount the volume group on the array the kernel panics,=
 and
>>>> the system hangs. Is that related to the incomplete conversion?
>>>
>>> The array should be part way through the conversion. =A0If you
>>> =A0 mdadm -E /dev/sda
>>> it should report something like "Reshape Position : XXXX" indicatin=
g
>>> how far along it is.
>>> The reshape will not restart while the array is read-only. =A0Once =
you make it
>>> writeable it will automatically restart the reshape from where it i=
s up to.
>>>
>>> The kernel panic is because the array is read-only and the filesyst=
em tries
>>> to write to it. =A0I think that is fixed in more recent kernels (i.=
e. ext4
>>> refuses to mount rather than trying and crashing).
>>>
>>> So you should just be able to "mdadm --read-write /dev/md0" to make=
 the array
>>> writable, and then continue using it ... until another device fails=
=2E
>>>
>>> Reverting the reshape is not currently possible. =A0Maybe it will b=
e with Linux
>>> 3.5 and mdadm-3.3, but that is all months away.
>>>
>>> I would recommend an "fsck -n /dev/md0" first and if that seems mos=
tly OK,
>>> and if "mdadm -E /dev/sda" reports the "Reshape Position" as expect=
ed, then
>>> make the array read-write, mount it, and backup any important data.
>>>
>>> NeilBrown
>>>
>>>
>>>>
>>>> Thanks,
>>>> --
>>>> H=E1kon G.
>>>>
>>>>
>>>>
>>>> On 8 May 2012 20:48, NeilBrown <neilb@suse.de> wrote:
>>>> >
>>>> > On Mon, 30 Apr 2012 13:59:56 +0000 H=E1kon G=EDslason
>>>> > <hakon.gislason@gmail.com>
>>>> > wrote:
>>>> >
>>>> > > Hello,
>>>> > > I've been having frequent drive "failures", as in, they are re=
ported
>>>> > > failed/bad and mdadm sends me an email telling me things went =
wrong,
>>>> > > etc... but after a reboot or two, they are perfectly fine agai=
n. I'm
>>>> > > not sure what it is, but this server is quite new and I think =
there
>>>> > > might be more behind it, bad memory or the motherboard (I've b=
een
>>>> > > having other issues as well). I've had 4 drive "failures" in t=
his
>>>> > > month, all different drives except for one, which "failed" twi=
ce, and
>>>> > > all have been fixed with a reboot or rebuild (all drives repor=
ted bad
>>>> > > by mdadm passed an extensive SMART test).
>>>> > > Due to this, I decided to convert my raid5 array to a raid6 ar=
ray
>>>> > > while I find the root cause of the problem.
>>>> > >
>>>> > > I started the conversion right after a drive failure & rebuild=
, but as
>>>> > > it had converted/reshaped aprox. 4%(if I remember correctly, a=
nd it
>>>> > > was going really slowly, ~7500 minutes to completion), it repo=
rted
>>>> > > another drive bad, and the conversion to raid6 stopped (it sai=
d
>>>> > > "rebuilding", but the speed was 0K/sec and the time left was a=
 few
>>>> > > million minutes.
>>>> > > After that happened, I tried to stop the array and reboot the =
server,
>>>> > > as I had done previously to get the reportedly "bad" drive wor=
king
>>>> > > again, but It=A0wouldn't=A0stop the array or reboot, neither c=
ould I
>>>> > > unmount it, it just hung whenever I tried to do something with
>>>> > > /dev/md0. After trying to reboot a few times, I just killed th=
e power
>>>> > > and re-started it.=A0Admittedly=A0this was probably not the be=
st thing I
>>>> > > could have done at that point.
>>>> > >
>>>> > > I have backup of ca. 80% of the data on there, it's been a mon=
th since
>>>> > > the last complete backup (because I ran out of backup disk spa=
ce).
>>>> > >
>>>> > > So, the big question, can the array be activated, and can it c=
omplete
>>>> > > the conversion to raid6? And will I get my data back?
>>>> > > I hope the data can be rescued, and any help I can get would b=
e much
>>>> > > appreciated!
>>>> > >
>>>> > > I'm fairly new to raid in general, and have been using mdadm f=
or about
>>>> > > a month now.
>>>> > > Here's some data:
>>>> > >
>>>> > > root@axiom:~# mdadm --examine --scan
>>>> > > ARRAY /dev/md/0 metadata=3D1.2 UUID=3Dcfedbfc1:feaee982:4e92cc=
f4:45e08ed1
>>>> > > name=3Daxiom.is:0
>>>> > >
>>>> > >
>>>> > > root@axiom:~# cat /proc/mdstat
>>>> > > Personalities : [raid6] [raid5] [raid4]
>>>> > > md0 : inactive sdc[6] sde[7] sdb[5] sda[4]
>>>> > > =A0 =A0 =A0 7814054240 blocks super 1.2
>>>> > >
>>>> > > root@axiom:~# mdadm --assemble --scan --force --run /dev/md0
>>>> > > mdadm: /dev/md0 is already in use.
>>>> > >
>>>> > > root@axiom:~# mdadm --stop /dev/md0
>>>> > > mdadm: stopped /dev/md0
>>>> > >
>>>> > > root@axiom:~# mdadm --assemble --scan --force --run /dev/md0
>>>> > > mdadm: Failed to restore critical section for reshape, sorry.
>>>> > > =A0 =A0 =A0 Possibly you needed to specify the --backup-file
>>>> > >
>>>> > > root@axiom:~# mdadm --assemble --scan --force --run /dev/md0
>>>> > > --backup-file=3D/root/mdadm-backup-file
>>>> > > mdadm: Failed to restore critical section for reshape, sorry.
>>>> >
>>>> > What version of mdadm are you using?
>>>> >
>>>> > I suggest getting a newer one (I'm about to release 3.2.4, but 3=
=2E2.3
>>>> > should
>>>> > be fine) and if just that doesn't help, add the "--invalid-backu=
p" option.
>>>> >
>>>> > However I very strongly suggest you try to resolve the problem w=
hich is
>>>> > causing your drives to fail. =A0Until you resolve that it will k=
eep
>>>> > happening
>>>> > and having it happen repeatly during the (slow) reshape process =
would not
>>>> > be
>>>> > good.
>>>> >
>>>> > Maybe plug the drives into another computer, or another controll=
er, while
>>>> > the
>>>> > reshape runs?
>>>> >
>>>> > NeilBrown
>>>> >
>>>> >
>>>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
