From: Hank Barta <hbarta@gmail.com>
Subject: Re: RAID for USB flash drives
Date: Tue, 18 Jan 2011 07:47:54 -0600
Message-ID: <AANLkTikxwP+OWu9gFDPDE8rkxDB4ZFroB5FSDUsWPPA-@mail.gmail.com>
References: <AANLkTi=kcbanFit5x27ccS_1RChxC=Dn+Hs4Ak+FbKsX@mail.gmail.com>
	<4D237E70.6030104@anonymous.org.uk>
	<AANLkTi=cOHgdradDDOFTdZ_xOGMXv8qf_n6xxppGA12y@mail.gmail.com>
	<4D320987.7020001@anonymous.org.uk>
	<AANLkTinQcu8jwKGiYViBP_CE0Hd4UbaO4spvMgnmRoa8@mail.gmail.com>
	<4D358490.4020400@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D358490.4020400@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 18, 2011 at 6:16 AM, John Robinson
<john.robinson@anonymous.org.uk> wrote:
> Did you mean to copy your message to the list? If so please go ahead =
and
> I'll also copy this reply to the list.

Yes, I meant to - thanks!

> Anyway: I only have experience of grub 0.9x, which has no knowledge o=
f md
> arrays. To boot from a md array using grub 0.9x, you have to make /bo=
ot a
> RAID-1 with metadata at the end of the array (so mdadm 0.90 or 1.0
> superblock), so that grub can read the bare partition as a filesystem
> without understanding that it's part of a md array. grub-install does=
 know
> about these arrays though, and will write its stage1 boot code into t=
he MBR
> and the stage1_5 filesystem code into the next few sectors of all the=
 drives
> participating in the array, so that whichever one the BIOS boots from=
, grub
> can read that mirror of the /boot filesystem and load the chosen kern=
el and
> initrd.

I'm not so sure that grub2 or the corresponding grub-install is any
further ahead on that account. I'm using Ubuntu which moved to grub2 a
couple releases ago. I'm using it for this attempt and it seemed not
to be able to install grub on a RAID0 drive. I tried both during the
initial install and subsequently booting from a live CD (on USB.)

IAC, I'm working with a non-RAID /boot partition at the moment. If I
get this up and running, it's not so hard to mirror that partition to
other drives.

>
> This is of course a fudge, because the system will fail to boot if th=
ere are
> bad sectors on the first drive where anything necessary to boot lives=
, even
> though there are good copies on another drive. (I've actually had thi=
s
> happen to me. I just told the BIOS to boot from the second drive unti=
l I
> could swap the faulty first drive.) This fudge is part of the reason =
for
> software RAID BIOSes and new grub.

I pretty much accept that. I think the only situation presently where
the raid would boot from a (second) RAID1 drive w/out intervention is
if the first drive failed in a way that it completely disappeared form
the system. I doubt that's a common situation.

>
> I understand that new grub does know how to read from md arrays, so
> potentially allowing booting from filesystems striped over several de=
vices
> e.g. RAID-0 and RAID-5 as well as handling RAID-1 mirrors rather bett=
er, and
> it moves the fudge factor to just the few sectors grub itself needs a=
nd
> means it can cope with the kernel and initrd images having bad sector=
s in
> them (for RAID-1 and RAID-5). Software RAID BIOSes and hardware RAID =
cards
> avoid the fudge factor altogether.

Progress is good! :)

Wish I had made more. :(

>
> It looks like you're using new grub, which I don't have any experienc=
e of,
> so I'm afraid can't help with it, though I don't suppose it's all tha=
t
> different except that it must have another stage between the MBR boot=
 code
> and the filesystem code.

Yes. And I may be battling a couple different problems. The testing I
described in the previous email was actually on another system (Eee PC
901) as it was simply more convenient. After I sent the email out I
tried the same USB sticks in the target system and found it fell far
short of the limited success I had with the Eee. I'm not sure it's
even loading the bootloader from the MBR. (Does that put anything on
the screen?) I can boot the Ubuntu install USB on that system so I
know it's capable of booting form a USB flash drive. But the install
USB sticks may be using some sort of emulation of the El Torrito
mechanism used to boot from CD.

Thanks again for your continuing help.

(Ordinarily I would trim quoted material from previous messages, but
I'll leave it intact since I forgot to CC the list with that.)

best,
hank

>
> On 17/01/2011 14:38, Hank Barta wrote:
>>
>> On Sat, Jan 15, 2011 at 2:54 PM, John Robinson
>> <john.robinson@anonymous.org.uk> =A0wrote:
>>>
>>> I'm sorry I wasn't clearer.
>>
>> No worries - you were clear enough. Lack of comprehension was my fau=
lt.
>>
>>>
>>> You will also need to make sure your initrd or initramfs includes t=
he USB
>>> drivers if it doesn't do that automatically, as well as the usb-sto=
rage,
>>> scsi and md modules for your root filesystem, and just to be sure I=
'd
>>> include raid1.ko so it can potentially start /boot as well.
>>
>> I'm working through what I believe may be grub issues on this. At
>> present I'm working with three USB sticks. I've mounted them on my
>> main laptop, started the RAID and then tweaked the GRUB configuratio=
ns
>> to put the menu up and add some boot options. I wanted to see the me=
nu
>> to try to determine just how far GRUB was getting. The boot options
>> are from one of the pages I referenced earlier:
>> kopt=3Dusb-storage.delay_use=3D1 rootfstype=3Dext4 rootflags=3Ddata=3D=
writeback
>>
>> (I have also tried it w/out "rootflags=3Ddata=3Dwriteback")
>>
>> The result is some progress during boot. Grub comes up and I get the
>> menu. When I select the preferred boot option, I can see it access t=
he
>> boot stick for a couple seconds. Then there is no visible activity
>> followed by access of all three sticks. After that, there is an erro=
r
>> message:
>>
>> mount: mounting /dev/md1 on /root failed: invalid argument
>>
>> This is followed by three errors indicating that /dev, /sys and /pro=
c
>> cannot be mounted due to "No such file or directory." After that an
>> error that init cannot be found (of course since root is not mounted=
=2E)
>>
>> At this point the console is dumped into BusyBox with the prompt
>> "(initramfs)" so it seems to me the problem is inability to mount th=
e
>> raid.
>>
>> At this point I can 'cat /dev/mdstat' and the raid appears active. B=
ut
>> attempts to mount it fail with the same "Invalid argument" error.
>>
>> The 'blkid' command identifies the USB boot partition and the three
>> RAID partitions but does not find /dev/md1.
>>
>> there are no logs, but dmesg ends with the md messages:
>> [...] md1: detected capacity change from 0 to 12027691008
>> [...] =A0md1: p1 p2
>> (There are a bunch of normal looking raid0 messages preceding this.)
>>
>> The menu entry I'm trying to boot from /boot/grub.cfg is:
>> menuentry 'Ubuntu, with Linux 2.6.32-24-generic-pae' --class ubuntu
>> --class gnu-linux --class gnu --class os {
>> =A0 =A0 =A0 =A0recordfail
>> =A0 =A0 =A0 =A0insmod ext2
>> =A0 =A0 =A0 =A0set root=3D'(hd1,1)'
>> =A0 =A0 =A0 =A0search --no-floppy --fs-uuid --set
>> 8db30d89-6a2b-4d41-842d-3bb8d24e14b8
>> =A0 =A0 =A0 =A0linux =A0 /vmlinuz-2.6.32-24-generic-pae root=3D/dev/=
md1 ro
>> kopt=3Dusb-storage.delay_use=3D1 rootfstype=3Dext4 =A0quiet
>> =A0 =A0 =A0 =A0initrd =A0/initrd.img-2.6.32-24-generic-pae
>> }
>>
>> So it seems that the initramfs loads and the raid gets started, but =
it
>> cannot mount the root fs on /dev/md1.
>>
>>>
>>> I may be being over-cautious with some of what I say above, but hop=
efully
>>> I've covered all the possibilities even if some are overkill, and y=
our
>>> installer is likely getting more right than I'm giving it credit fo=
r.
>>
>> I did find some reports of nasty bugs regarding the installer gettin=
g
>> things very wrong, but I think those issues have been fixed.
>>
>>> Anyway, once again, good luck!


--=20
'03 BMW F650CS - hers
'98 Dakar K12RS - "BABY K" grew up.
'93 R100R w/ Velorex 700 (MBD starts...)
'95 Miata - "OUR LC"
polish visor: apply squashed bugs, rinse, repeat
Beautiful Sunny Winfield, Illinois
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
