From: Another Sillyname <anothersname@googlemail.com>
Subject: Fwd: Installing Linux directly onto RAID6 Array...........
Date: Tue, 12 May 2015 14:12:10 +0100
Message-ID: <CAOS+5GE1DTzuARuPPRMvhzB46Ka5snF+MZqyM_tbLH7uY9_VuQ@mail.gmail.com>
References: <CAOS+5GFwGJouUfZ_RWhtRVXw7wnoP1Ry4doHTJmkruFoccmqRg@mail.gmail.com>
	<5551D3F2.8020007@grumpydevil.homelinux.org>
	<5551F01A.4050705@turmel.org>
	<20150512173147.0d2c3363@natsu>
	<CAOS+5GHhUoYxTTYOWU7cdN6GSdffSMGrhWHU5ZtWEjc4jEm3eg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOS+5GHhUoYxTTYOWU7cdN6GSdffSMGrhWHU5ZtWEjc4jEm3eg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

---------- Forwarded message ----------
From: Another Sillyname <anothersname@googlemail.com>
Date: 12 May 2015 at 14:11
Subject: Re: Installing Linux directly onto RAID6 Array...........
To: Roman Mamedov <rm@romanrm.net>


Guys

Don't want to use USB as the machine may sometimes be in a non secure
environ, want to boot direct from Raid.

Reading more think there may be a way....

https://help.ubuntu.com/community/Grub2/Installing

there's an interesting idea in there of effectively installing the
bootloader onto every drive in the array......

On 12 May 2015 at 13:31, Roman Mamedov <rm@romanrm.net> wrote:
> On Tue, 12 May 2015 08:20:42 -0400
> Phil Turmel <philip@turmel.org> wrote:
>
>> > Doing something like that... and using network boot to solve those issues
>> >
>> > Last i tried grub2 could not handle a raid6 directly (could be changed now)
>>
>> You could also boot from a USB device, possibly one that memory caches
>> its root filesystem (like System Rescue CD).
>
> Just place GRUB and the /boot partition with kernel and initrd on a USB stick,
> the rest (root FS) can be on RAID6. That's what I do on one machine.
>
> --
> With respect,
> Roman
