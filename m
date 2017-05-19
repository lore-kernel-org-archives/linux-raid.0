From: Victor Helmholtz <victor.helmholtz@gmail.com>
Subject: Re: How to backup of large md raid volumes?
Date: Fri, 19 May 2017 05:36:07 +0100
Message-ID: <D1B586A9-7094-44F4-9FD9-566D0DCC2178@gmail.com>
References: <442a4af0-00d2-853d-5294-84ae0353262b@gmail.com> <75dc802b-1572-3c6f-ed62-4333deece4c2@websitemanagers.com.au> <8b840e53-1be2-b1b5-632f-e75f0c6c53b7@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8b840e53-1be2-b1b5-632f-e75f0c6c53b7@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


> On 19 May 2017, at 04:39, Ram Ramesh <rramesh2400@gmail.com> wrote:
>=20
> On 05/18/2017 08:34 PM, Adam Goryachev wrote:
>> On 19/05/17 07:37, Ram Ramesh wrote:
>>> Any one have a method to backup large volumes like md raid6 (16TB)? =
Since the backup will not fit in one disk (in many cases and mine too) I =
am wondering, if there is a known/easy technique to backup using =
multiple usb hard drives. I googed and found a few fancy backup =
utils/systems like Amanda etc. They are overkill for me. I am choosing =
not to back up simply because of the complexity of setup as the data in =
my RAID volume is NOT precious and can be replaced with a week of =
effort.
>>>=20
>>> If any one can think of some thing simple, please point me to it and =
I will do the reading to figure out.
>>>=20
>> I suppose it depends on what you want to achieve. There are various =
options such as mirroring to another raid6 array (ie, RAID60) but really =
that isn't a backup, it's another replica.
>> I use backuppc for my backups, it works well under linux with rsync, =
I'm sure there are many various options (including amanda which I've =
used in the past). Ultimately, it depends on your requirements, backups =
vary significantly depending on needs/etc.
>>=20
>> Regards,
>> Adam
>>=20
>>=20
> Here is a summary of what I like to do. I want to backup files on to =
(multiple) disks that will be loaded on to a USB dock. Simple one to one =
copy is all I am looking for. I am not interested in full vs. =
incremental or keeping versions of files for restore. My data is just =
movies and songs. All I want is a SW that understands links (to avoid =
duplicates) and copy files in batch on to multiple disks. I want content =
of each (backup) disk to be independent. This way if one backup disk =
dies, I have all other files unaffected by this failure. The only reason =
I did not try multi-volume tar is the lack of independence across disks.
>=20
> I suppose this is a backup question rather than RAID question. I asked =
here because the size of RAID volumes make it impossible to back up to a =
single drive and this is a more common problem RAID world rather than =
general user forum in a backup mailing list.
>=20
> Ramesh
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I have never tried it myself, but my understanding is that in =
multi-volume GNU tar archive each volume is independent. Tar manual =
states:
> Each volume is itself a valid GNU tar archive, so it can be read =
without any special options. Consequently any file member residing =
entirely on one volume can be extracted or otherwise operated upon =
without needing the other volume. Sure enough, to extract a split member =
you would need all volumes its parts reside on.

Regards
Victor=
