From: =?ISO-8859-15?Q?Vasco_N=E9voa?= <vasco.nevoa@sapo.pt>
Subject: Re: how to recover filesystem after clobbering array?
Date: Sat, 23 Jul 2011 09:19:44 +0100
Message-ID: <4E2A8420.5000603@sapo.pt>
References: <20110719104325.16112cl7f4lrzkjh@mail.sapo.pt>	<j03lp4$h72$1@dough.gmane.org> <4E255FE1.2060006@tolaris.com> <20110719120153.1529669k4o1t6v4x@mail.sapo.pt>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110719120153.1529669k4o1t6v4x@mail.sapo.pt>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I've successfully recovered my array data. :)
All it took was, as I expected, to rebuild the right pointers. The data=
=20
was always untouched.
Here it goes, for the sake of completeness.

I initially used "mdadm --create --assume-clean ..." on a level1 array=20
of 2 disks that came from another machine. I didn't know any other way=20
of starting an array in this situation. While this is an acceptable=20
practice in some cases, it is better to use "--assemble" and pass the=20
necessary info (like uuid).

Unfortunately I apparently lost all the data because the newly created=20
metadata superblock was the default 0.9 version, and the original array=
=20
metadata version was 1.2, and this resulted in a missing partition tabl=
e=20
once the array was run.

Then I retrieved the mdadm.conf file from the original machine, and=20
there I found the correct metadata version, uuid, array name, array=20
device name. I also double-checked the volume partition and filesystem=20
type from that machine's /etc/fstab.

So, I zeroed-out the metadata superblocks with "mdadm --zero-superblock=
=20
=2E..", and then proceeded to restore the original metadata superblock=20
with "mdadm --create --assume-clean --metadata=3D1.2 --uuid=3D...=20
--name=3D...  --level=3D1 --raid-devices=3D2 /dev/sde1 missing", and it=
 worked=20
just fine. The array was started and I could see the original data=20
partition with fdisk and actually mount it. After this successful test,=
=20
I just added the other disk to the array.

The one information I expected from this list was: "No problem, your=20
data is still there. If you can recreate the superblock with the same=20
metadata version as it used to be, everything reverts to normal."=20
Unfortunately I had no such support.

Cheers,
Vasco.

On 19-07-2011 12:01, Vasco N=E9voa wrote:
> Thank you very much, Tyler and David.
> Good advice.
>
> The array is level 1, built upon primary partitions of the devices.
> The file system is EXT4.
> The mdadm command that I stupidly used to create instead of starting=20
> the array included "--assume-clean" but no "--build".
> I checked via /proc/mdadm that the array came up without syncing=20
> anything (or at least it was ultra-fast, less than 5 seconds).
> So I firmly believe the data is all there, on both disks.
> I just need to rebuild the metadata to point to the data again someho=
w.
> Right?...
>
> Citando "Tyler J. Wagner" <tyler@tolaris.com>:
>
>> On 2011-07-19 11:17, David Brown wrote:
>>> Once you have got image files for each of your disks, make copies o=
f
>>> these image files to another spare disk. Keep careful notes of exac=
tly
>>> what you have done here, and which files are which. And put your
>>> original disks, carefully labelled, on a shelf somewhere.
>>>
>>> Now you are in a position to attempt data recovery on your copied
>>> files. If you do something wrong, you can simply re-copy the image
>>> files and try again. You still have absolutely no guarantees that
>>> you'll get anything back - but at least you can be sure you are not
>>> going to make anything worse.
>>
>> Follow David's advice.
>>
>> What was the filesystem on the array?
>>
>> Now, use testdisk, photorec, and foremost to seek through the raw im=
ages
>> and extract files. The good news is, most video formats are detectab=
le
>> by these tools. All can be installed with your package manager.
>>
>> Regards,
>> Tyler
>>
>> --=20
>> "Offending fundamentalists isn't my goal - but if it is an inevitabl=
e
>> side-effect of defending human rights, so be it."
>>    -- Johann Hari
>>
>> --=20
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
