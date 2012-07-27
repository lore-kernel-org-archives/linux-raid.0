From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: [RFE] Please, add optional RAID1 feature (= chunk checksums) to
 make it more robust
Date: Fri, 27 Jul 2012 10:42:59 -0300
Message-ID: <CABYL=TrMbrFz7JY6NjidbhEwt7F8mC6iXkMGfPJcV+uDbh07RQ@mail.gmail.com>
References: <500CD32E.4000800@hardwarefreak.com>
	<542194327.593466.1343036057599.JavaMail.root@redhat.com>
	<20120723170320.GA2691@lazy.lzy>
	<CABYL=Tq0w150QMcehdsScUfDfCD2tGFeuROjWjwsepy1rRXk_w@mail.gmail.com>
	<CACJz6Qu6qVAroTTZJL=Q_Gs5VRsn=VttaKMu0WOKCh2sdJdgqQ@mail.gmail.com>
	<50122FCA.3070304@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50122FCA.3070304@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

IMO
the first idea was put this only in md_raid1,
the second idea was a new md device (maybe a md_security or
md_redundancy or md_conformity or any another beautiful name...) in
this case the device will do a checksum and report 'badblock' (maybe
the right word could be badchecksum), that the option that i agree,
since we could do it to any device, doesn=B4t matter if it=B4s a raid1 =
or
raid4 or raidXYZ

just to explain words:
badchecksum -> we can read data but we know that it doesn=B4t match
checksum, or checksum doesn=B4t match data
badblock -> we can=B4t read, because 'physical block' reported as bad

for mirror layers we could do more than just know if we have a
badchecksum (this is not good, check...)
in the case of all mirrors reporting badchecksum, we could read data
(doesn=B4t matter the badchecksum information) and vote to the data tha=
t
have more repeated values and resync data from this new 'primary
information', for example:

/dev/md0 -> disks: /dev/sda /dev/sdb /dev/sdc
original data: block=3D "ABCDEF", checksum=3D5

for /dev/sda: block=3D"ABCDEH", checksum=3D5 (badchecksum)
for /dev/sdb: block=3D"ABCDEG", checksum=3D5 (badchecksum)
for /dev/sdc: block=3D"ABCDEG", checksum=3D5 (badchecksum)

in this case, we could elect "ABCEG" (2 repeats) as the 'new data'
recalcule the checksum and sync data to all devices (check that we
coudl have a a 1 repeat for each device and couln=B4t elect the new
primary information source...)

well this ideal could be good and bad... for application level that=B4s
bad, since we done a silent data corruption..., but maybe for a
recovery tool this could be good since we corrected the checksum...
maybe this could be a tool of the new device level... (CHECKS and
REPAIRS like mdadm do today with echo "check">
/sys/block/md0/md/sync_action, or echo "repair" >
/sys/block/md0/md/sync_action )

i don=B4t like the idea of put the 'recovery' inside md_raid1, i prefer
a badblock per device (doesn=B4t matter if it=B4s a badblock or
badchecksum..), and don=B4t do any 'silent recover' of information at
raid level, to do a checksum correction or data correction, maybe
leave this problem to a external tool, like harddisks have badblocks
tools, we could have a badblock tool too

going back to our new device,
check that a data corruption (silent or not) is a data corruption, and
in any case (checksum corruption or data corruption) we have a bad
device, and we should report that we have a badblock in that read
operation
the best we could do when we have a badchecksum is reread many times
and recalculate the checksum, if the good matches are bigger than X%
(maybe 80%) we could send a write to device (to ensure that disk wrote
the good value to disk again) and do a new read if that match (only
with 1 read) that=B4s nice we done a good 'silent' repair with a 'good'
(80% of probabilty of good) data, this could be an option of the new
device to the new device ("silent recover")


i think that=B4s all we could do of interesting =3D)
maybe in some future... we could do a realoc?! like ssd do...
mark the badchecksum block as badblock (inside a badblock list) and
sync the data inside current badblock, to a new never used block (we
could alloc 1% of device to use as never used blocks), this could be
good for data security, but administrator should read logs to ensure
that system don=B4t run with badblocks....

that=B4s are the ideas of the 'new' security device level that i could =
imagine...
thanks guys :)


2012/7/27 Adam Goryachev <mailinglists@websitemanagers.com.au>:
> On 24/07/12 07:31, Drew wrote:
>> Been mulling this problem over and I keep getting hung up on one
>> problem with ECC on a two disk RAID1 setup.
>>
>> In the event of silent corruption of one disk, which one is the good
>> copy?
>>
>> It works fine if the ECC code is identical across both mirrors. Just
>> checksum both chunks and discard the incorrect one.
>>
>> It also works fine if the ECC codes are corrupted but the data
>> chunks are identical. Discard the bad checksum.
>>
>> What if the corruption goes across several sectors and both data &
>> ECC chuncks are corrupted? Now you're back to square one.
>
> I know I'm a bit late to this discussion, and I know very little abou=
t
> the code level/etc... however, I thought the whole point of the check=
sum
> is to determine that the data + checksum do not match, therefore the
> data is wrong and should be discarded. You would re-write the data an=
d
> checksum from another source (ie, the other drive in RAID1, or other
> drives in RAID5/6 etc...).
>
> ie, it should be treated the same as a bad block / non-readable secto=
r
> (or lots of unreadable sectors....)
>
> Regards,
> Adam
>
>
> --
> Adam Goryachev
> Website Managers
> www.websitemanagers.com.au
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
