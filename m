From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Growing 6 HDD RAID5 to 7 HDD RAID6
Date: Wed, 13 Apr 2011 12:44:48 +0100
Message-ID: <4DA58CB0.3020109@anonymous.org.uk>
References: <BANLkTi=yZkM464MbvEgAjEWPGrR+eieXCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=yZkM464MbvEgAjEWPGrR+eieXCg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

(Subject line amended by me :-)

On 12/04/2011 17:56, Mathias Bur=C3=A9n wrote:
[...]
> I'm approaching over 6.5TB of data, and with an array this large I'd
> like to migrate to RAID6 for a bit more safety. I'm just checking if =
I
> understand this correctly, this is how to do it:
>
> * Add a HDD to the array as a hot spare:
> mdadm --manage /dev/md0 --add /dev/sdh1
>
> * Migrate the array to RAID6:
> mdadm --grow /dev/md0 --raid-devices 7 --level 6

You will need a --backup-file to do this, on another device. Since you=20
are keeping the same number of data discs before and after the reshape,=
=20
the backup file will be needed throughout the reshape, so the reshape=20
will take perhaps twice as long as a grow or shrink. If your backup-fil=
e=20
is on the same disc(s) as md0 is (e.g. on another partition or array=20
made up of other partitions on the same disc(s)), it will take way=20
longer (gazillions of seeks), so I'd recommend a separate drive or if=20
you have one a small SSD for the backup file.

Doing the above with --layout=3Dpreserve will save you doing the reshap=
e=20
so you won't need the backup file, but there will still be an initial=20
sync of the Q parity, and the layout will be RAID4-alike with all the Q=
=20
parity on one drive so it's possible its performance will be RAID4-alik=
e=20
too i.e. small writes never faster than the parity drive. Having said=20
that, streamed writes can still potentially go as fast as your 5 data=20
discs, as per your RAID5. In practice, I'd be surprised if it was faste=
r=20
than about twice the speed of a single drive (the same as your current=20
RAID5), and as Neil Brown notes in his reply, RAID6 doesn't currently=20
have the read-modify-write optimisation for small writes so small write=
=20
performance is liable to be even poorer than your RAID5 in either layou=
t.

You will never lose any redundancy in either of the above, but you won'=
t=20
gain RAID6 double redundancy until the reshape (or Q-drive sync with=20
--layout=3Dpreserve) has completed - just the same as if you were=20
replacing a dead drive in an existing RAID6.

Hope the above helps!

Cheers,

John.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
