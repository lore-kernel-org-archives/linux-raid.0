From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: raid1 with rotating offsite disks for backup
Date: Tue, 8 Feb 2011 03:37:40 -0200
Message-ID: <AANLkTik3BfXJ9ys36F3LspCzR10D_3zT7Vo_5asRNmT0@mail.gmail.com>
References: <20110208111743.1479308d@notabene.brown>
	<A3.F7.13137.B4CC05D4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A3.F7.13137.B4CC05D4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: NeilBrown <neilb@suse.de>, Jeff Klingner <klingner@stanford.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i think that a 4 disks array using spare disks is better
first... if you remove 1 mirror (2 mirrors maybe 2 disks...), you have
a protection problem (you don't have redundat array with only 1 mirror
working)
with 4 disks... 2 mirrors, to start backup put a spare online, wait it
to sync, remove it
if you have problem when resync, you have a second spare (the new
backup), and consider the resync disk, as the new array disk (not more
a backup disk)

it's like a online backup... i think we can implement it as snapshot
(on filesystem level) but since we can make it at lower level, it's a
nice feature... i think 4 disks is more secure... 3 disks is just more
cheap..

2011/2/8 Leslie Rhorer <lrhorer@satx.rr.com>:
>
>
>> -----Original Message-----
>> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
>> owner@vger.kernel.org] On Behalf Of NeilBrown
>> Sent: Monday, February 07, 2011 6:18 PM
>> To: Jeff Klingner
>> Cc: linux-raid@vger.kernel.org
>> Subject: Re: raid1 with rotating offsite disks for backup
>>
>> On Mon, 7 Feb 2011 15:53:46 -0800 Jeff Klingner <klingner@stanford.e=
du>
>> wrote:
>>
>> > I'm planning a backup system for my home server and have run into =
a
>> question I can't find answered in the mailing list archives or the w=
iki.
>> Here's the plan:
>> >
>> > 1. Install system and valuable data on a 3-disk raid1 array (call =
the
>> disks A, B, and C).
>> > 2. Remove disk C, put it offsite. =A0("offsite" is moderately time=
-
>> consuming to get to.)
>> > 3a. Periodically, remove disk B, take it offsite, and retrieve dis=
k C
>> > 3b. Insert disk C, which will be re-synced to gain any changes mad=
e
>> since it was removed.
>> > 4. Repeat steps 3a and 3b indefinitely, alternating the roles of d=
isks B
>> and C.
>> >
>> > Thus I hope to get continuous protection against a single drive fa=
ilure
>> and protection back to the last offsite swap for corrupted or delete=
d
>> data.
>> >
>> > My questions are:
>> >
>> > In step 3b, when a disk that was a member of the array in the past=
 but
>> has been removed for a while is re-inserted into the 3-disk array, h=
ow
>> does the raid system know to update C with A's contents and not A wi=
th C's
>> contents? =A0Is there a timestamp involved, and if so, how can I exa=
mine it
>> before syncing?
>> >
>> > Is it important to always rotate disks B and C, leaving one that n=
ever
>> leaves the computer, or does it make no difference which of the two =
live
>> disks I pluck out to swap with the offsite disk when I make the trip=
? =A0Can
>> all three disks take turns offsite, so that they all have the same d=
uty
>> cycle?
>> >
>> > I saw in another list message the advice to use two stacked raid1s=
 for
>> this application: http://marc.info/?l=3Dlinux-raid&m=3D1267613990087=
75&w=3D2
>> > > Also, if you want two rotating backups I would create two stacke=
d
>> raid1s.
>> > >
>> > > mdadm -C /dev/md0 -l1 -n2 -b internal =A0/dev/main-device /dev/f=
irst-
>> backup
>> > > mdadm -C /dev/md1 -l1 -n2 -b internal /dev/md0 /dev/second-backu=
p
>> > > mkfs -j /dev/md1
>> >
>> >
>> > Are there important differences between the single 3-disk raid1 ar=
ray
>> I'm planning to use and this stacked configuration?
>>
>> Yes. =A0The single 3-disk RAID1 array won't work, the stacked config=
uration
>> will.
>
> =A0 =A0 =A0 =A0Oh. =A0I think I mis-read his original post. =A0When I=
 read it the first
> time, I inferred he was attempting this to do a full backup of the ar=
ray.
> Reading again, I think you are correct. =A0If he wants to just update=
 the data
> on the array, I think rsync (or maybe dar) would be a better solution=
=2E =A0If
> he wants a full backup from scratch, I don't see why a RAID1 solution=
 would
> not work, do you?
>
>> md can resync 'just the changed blocks' by using the 'write intent b=
itmap'
>> and event counters.
>> However it only clears the bits in the bitmap when the array is not
>> degraded.
>> In your suggestion the 3-drive RAID1 is always degraded so bits are =
never
>> cleared, so each resync is effectively a complete resync.
>
> =A0 =A0 =A0 =A0Yeah, to do a full backup from scratch, I think I woul=
d set the
> array up as a 2 drive array, take the array off-line, remove one driv=
e,
> assemble the array, and then add the spare. =A0'Clumsy, though. =A0I =
still think
> he would be better off with rsync or dar.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
