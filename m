From: Randy Terbush <randy@terbush.org>
Subject: Re: Questions regarding startup of imsm container
Date: Tue, 23 Mar 2010 22:14:35 -0600
Message-ID: <7db987b31003232114s374a26f9w881c1249c30b0fc6@mail.gmail.com>
References: <7db987b31003222056i46c42112s541ba949821a6759@mail.gmail.com>
	<e9c3a7c21003231401p55d4e392u22b062aaf464b1da@mail.gmail.com>
	<7db987b31003231441j56733b15wd111c4aa22e9eccc@mail.gmail.com>
	<4BA93DBB.6000503@intel.com> <7db987b31003231625obb9f3c5r986988defdf68a08@mail.gmail.com>
	<7db987b31003231723tac48bf5ocb3723522dc54417@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7db987b31003231723tac48bf5ocb3723522dc54417@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

The array is now surviving a reboot without dropping into a resync
when we start back up.

However, the external bitmap is not getting recreated. My mdadm.conf
looks like this:

ARRAY /dev/md/0 metadata=3Dimsm UUID=3D30223250:76fd248b:50280919:0836b=
7f0
ARRAY /dev/md/127 container=3D30223250:76fd248b:50280919:0836b7f0
member=3D0 bitmap=3D/boot/md/127-RAID5-bitmap
UUID=3D8a4ae452:da1e7832:70ecf895:eb58229c

The /boot partition is being mounted but may not be mounted at the
time the array is started. Not finding any error messages in logs
regarding the bitmap. The help is much appreciated.

On Tue, Mar 23, 2010 at 6:23 PM, Randy Terbush <randy@terbush.org> wrot=
e:
> Update on progress....
>
> I have managed to hack together a dracut created initramfs that has m=
e
> able to boot and has resolved all boot issues. Will let this thing
> have a few hours of resyncing and see if external bitmap comes back
> and how it handles the reboot.
>
> Thanks again for the assistance.
>
> On Tue, Mar 23, 2010 at 5:25 PM, Randy Terbush <randy@terbush.org> wr=
ote:
>> Thanks Dan, a few more steps forward here. I suspect I know the
>> answer, but will see what you suggest.
>>
>> On Tue, Mar 23, 2010 at 4:16 PM, Dan Williams <dan.j.williams@intel.=
com> wrote:
>>> This shows that Gentoo is most likely not including mdmon in their =
initramfs
>>> environment. =A0mdadm assembles the array readonly, but then mdmon =
is required
>>> to mark the array writable.
>>
>> Looks like you are correct and current installation packages on Gent=
oo
>> have apparently not dealt with these changes. mdmon is not getting
>> started and is not being attempted anywhere.
>>
>> I don't run an initrd, so attempted to start mdmon after the mdadm -=
As
>> runs. This is apparently too early in the process as I get the
>> following:
>>
>> * Starting up RAID devices ...
>> =A0[ ok ]
>> mdmon: Neither /var/run nor /lib/init/rw are writable
>> =A0 =A0 =A0 cannot create .pid or .sock files. =A0Aborting
>> =A0* Setting up the Logical Volume Manager ...
>> =A0[ ok ]
>> =A0* Checking local filesystems =A0...
>> HOME-vg0: clean, 13/3276800 files, 256151/52428800 blocks
>> Warning... fsck.ext4 for device /dev/mapper/vg0-home exited with sig=
nal 11.
>> SVN-vg0: clean, 191/1638400 files, 153087/26214400 blocks
>> Warning... fsck.ext4 for device /dev/mapper/vg0-svn exited with sign=
al 11.
>> ARCHIVE-vg0: clean, 12/1638400 files, 152150/26214400 blocks
>>
>> So it appears the start of mdmon needs to wait until we have a rw
>> filesystem mounted. Not entirely sure if it is related, but as you c=
an
>> see above, fsck blows up trying to check the filesystems on this
>> array. That appears to clear itself up once mdmon is running. After
>> starting mdmon by hand, the resync begins and I can successfully run
>> fsck on these partitions.
>>
>> So looks like I have a chicken and egg problem that I suspect may be
>> solved by creating an initramfs. I took a quick pass at dracut but
>> could not convince it to add mdmon. Any hints appreciated as I go ba=
ck
>> to dig for more info.
>>
>> Thanks again for the assistance.
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
