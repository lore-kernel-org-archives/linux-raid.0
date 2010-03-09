From: rj <ratnadeep@gmail.com>
Subject: Re: Does MD solve write hole issue for RAID5/RAID6?
Date: Tue, 9 Mar 2010 08:44:05 +0530
Message-ID: <d19eda751003081914sae34e1fv9d923e6be0bc658d@mail.gmail.com>
References: <d19eda751003030417o3a7ec761ua54e93875002410a@mail.gmail.com>
	 <4B8E66E5.9050606@shiftmail.org> <87wrxqy37l.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87wrxqy37l.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Asdo <asdo@shiftmail.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

okay, thanks guys !

On Sat, Mar 6, 2010 at 1:02 AM, Goswin von Brederlow <goswin-v-b@web.de=
> wrote:
> Asdo <asdo@shiftmail.org> writes:
>
>> rj wrote:
>>> Hi,
>>> I wanted to know if md solves write hole issue for RAID5/RAID6?
>
> It is unsolvable without a crash persistant journal. Hardware raids h=
ave
> battery backed cache for that but a fast disk would also work. But no
> support for this in linux software raid.
>
>> No but the filesystem can do that, ext3/4 and XFS in particular, if
>> well aligned on the RAID, if you are creating new files and not
>> updating old files (i.e. doesn't work for databases).
>> For full write hole avoidance you need to wait for Btrfs (and I don'=
t
>> know the state of raid-5/6 on btrfs), or use ZFS on Solaris or Freeb=
sd.
>
> No raid5/6 in btrfs. Needs major restructuring of the on-disk data fo=
r
> that.
>
> ZFS on the other hand uses what they call raid-x. Which is a raid5 wi=
th
> copy-on-write semantic. Any write to a virtual block will write to a =
new
> physical block and update the parity to a new physical block too. Onl=
y
> once that was written is the stripe atomically changed to the new
> physical location. So no hole there.
>
> There is also a zfs-fuse implementation for linux.
>
>>> Also, does md support RAID 50 level ?
>>>
>> Not directly, but you can create that manually by overlaying a raid =
0
>> over 1+ raid5's.
>
> And by layering one raid over others you can get any level you like,
> even 14065 if you like (and have enought disks).
>
> For raid50 I would suggest LVM over raid5 with striping though. Raid =
0
> is somewhat pointless when compared with all the extra flexibility LV=
M
> gives you on top of striping.
>
> MfG
> =A0 =A0 =A0 =A0Goswin
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
