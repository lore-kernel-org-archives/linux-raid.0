From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: What's the typical RAID10 setup?
Date: Thu, 3 Feb 2011 14:16:32 -0200
Message-ID: <AANLkTi=yDZrGGDJ4+dsNzeY4eA-MANWT7Dk-OvmZU155@mail.gmail.com>
References: <ii8lcv$3jg$1@dough.gmane.org>
	<AANLkTin1MPYZGMuL75c=_q+ndeiz0F5+eCRudpDdTwu9@mail.gmail.com>
	<ii96gl$vrl$1@dough.gmane.org>
	<AANLkTim3UgP0jtM6E_-3o-_OuNw6j1JG8OZzcvxt8A8s@mail.gmail.com>
	<AANLkTikehWC6-wzWE26p0n7Ng1YW6Sv_L1xU_K4LZdkv@mail.gmail.com>
	<AANLkTikerSZfhMbkEvGBVyLB=wHDSHLWszoEz5As5Hi4@mail.gmail.com>
	<AANLkTikLyR206x4aMy+veNkWPV67uF9r5dZKGqXJUEqN@mail.gmail.com>
	<AANLkTikzNHJFDfXbQEduu3=OwoaSwVp+p186K5rW1AXH@mail.gmail.com>
	<20110203154305.GA27356@www2.open-std.org>
	<AANLkTinKHG0dE0BeXX3v1z9my4+jDLebc96vMHJpjHDB@mail.gmail.com>
	<20110203160245.GD27356@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110203160245.GD27356@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>
Cc: Drew <drew.kay@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

i was trying to search coder for round robin balance, i founded Roy Kee=
ne
how could we contact him and tell if he could help us?

http://www.spinics.net/lists/raid/msg30003.html


2011/2/3 Keld J=F8rn Simonsen <keld@keldix.com>:
> On Thu, Feb 03, 2011 at 01:50:49PM -0200, Roberto Spadim wrote:
>> hummm, nice
>> keld (or anyone), do you know someone (with time, not much, total ti=
me
>> i think it?s just 2 hours) to try develop modifications on raid1
>> read_balance function?
>
> maybe our very productive Polish friends at Intel could have a look.
> But then again, I am not sure it is productive. I think raid1 is OK,
> You could have a look at raid10, where "offset" has been discussed as
> being the better layout for ssd.
>
>> what modification, today read_balance have distance (current_head -
>> next_head), multiply it by a number at /sys/block/md0/distance_rate,
>> and make add read_size*byte_rate (byte_rate at
>> /sys/block/md0/byte_read_rate), with this, the algorithm will make
>> minimal time, and not minimal distance
>> with this, i can get better read_balance (for ssd)
>> for a second time we could implement device queue time to end (i thi=
nk
>> we will work about 1 day to get it working with all device
>> schedulers), but it?s not for now
>
> Hmm, I thought you wanted to write new elevator schedulers?
>
> best regards
> keld
>
>>
>> 2011/2/3 Keld J=F8rn Simonsen <keld@keldix.com>:
>> > On Thu, Feb 03, 2011 at 12:35:52PM -0200, Roberto Spadim wrote:
>> >> =3D] i think that we can end discussion and conclude that context=
 (test
>> >> / production) allow or don't allow lucky on probability, what's l=
ucky?
>> >> for production, lucky =3D poor disk, for production we don't allo=
w
>> >> failed disks, we have smart to predict, and when a disk fail we c=
hange
>> >> many disks to prevent another disk fail
>> >>
>> >> could we update our raid wiki with some informations about this d=
iscussion?
>> >
>> > I would like to, but it is a bit complicated.
>> > Anyway I think there already is something there on the wiki.
>> > And then, for one of the most important raid types in Linux MD,
>> > namely raid10, I am not sure what to write. It could be raid1+0, o=
r
>> > raid0+1 like, and as far as I kow, it is raid0+1 for F2:-(
>> > but I don't know for n2 and o2.
>> >
>> > The German version on raid at wikipedia has a lot of info on proba=
bility
>> > http://de.wikipedia.org/wiki/RAID - but it is wrong a number of pl=
aces.
>> > I have tried to correct it, but the German version is moderated, a=
nd
>> > they don't know what they are writing about.
>
> at least in some places, refusing to correct errors.
>
>> > http://de.wikipedia.org/wiki/RAID
>> >
>> > Best regards
>> > Keld
>> >
>> >> 2011/2/3 Drew <drew.kay@gmail.com>:
>> >> >> for test, raid1 and after raid0 have better probability to don=
't stop
>> >> >> raid10, but it's a probability... don't believe in lucky, sinc=
e it's
>> >> >> just for test, not production, it doesn't matter...
>> >> >>
>> >> >> what i whould implement? for production? anyone, if a disk fai=
l, all
>> >> >> array should be replaced (if without money replace disk with s=
mall
>> >> >> life)
>> >> >
>> >> > A lot of this discussion about failure rates and probabilities =
is
>> >> > academic. There are assumptions about each disk having it's own
>> >> > independent failure probability, which if that can not be predi=
cted
>> >> > must be assumed to be 50%. =A0At the end of the day I agree tha=
t when
>> >> > the first disk fails the RAID is degraded and one *must* take s=
teps to
>> >> > remedy that. This discussion is more about why RAID 10 (1+0) is=
 better
>> >> > then 0+1.
>> >> >
>> >> > On our production systems we work with our vendor to ensure the
>> >> > individual drives we get aren't from the same batch/production =
run,
>> >> > thereby mitigating some issues around flaws in specific batches=
=2E We
>> >> > keep spare drives on hand for all three RAID arrays, so as to m=
inimize
>> >> > the time we're operating in a degraded state. All data on RAID =
arrays
>> >> > is backed up nightly to storage which is then mirrored off-site=
=2E
>> >> >
>> >> > At the end of the day our decision around what RAID type (10/5/=
6) to
>> >> > use was based on a balance between performance, safety, & capac=
ity
>> >> > then on specific failure criteria. RAID 10 backs the iSCSI LUN =
that
>> >> > our VMware cluster uses for the individual OSes, and the data
>> >> > partition for the accounting database server. RAID 5 backs the
>> >> > partitions we store user data one. And RAID 6 backs the NASes w=
e use
>> >> > for our backup system.
>> >> >
>> >> > RAID 10 was chosen for performance reasons. It doesn't have to
>> >> > calculate parity on every write so for the OS & database, which=
 do a
>> >> > lot of small reads & writes, it's faster. For user disks we wen=
t with
>> >> > RAID 5 because we get more space in the array at a small perfor=
mance
>> >> > penalty, which is fine as the users have to access the file ser=
ver
>> >> > over the LAN and the bottle neck is the pipe between the switch=
 & the
>> >> > VM, not between the iSCSI SAN & the server. For backups we went=
 with
>> >> > RAID 6 because the performance & storage penalties for the arra=
y were
>> >> > outweighed by the need for maximum safety.
>> >> >
>> >> >
>> >> >
>> >> > --
>> >> > Drew
>> >> >
>> >> > "Nothing in life is to be feared. It is only to be understood."
>> >> > --Marie Curie
>> >> >
>> >> >
>> >>
>> >>
>> >>
>> >> --
>> >> Roberto Spadim
>> >> Spadim Technology / SPAEmpresarial
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-r=
aid" in
>> >> the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at =A0http://vger.kernel.org/majordomo-info.h=
tml
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-ra=
id" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
>> >
>>
>>
>>
>> --
>> Roberto Spadim
>> Spadim Technology / SPAEmpresarial
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
