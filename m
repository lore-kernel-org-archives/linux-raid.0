From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: What's the typical RAID10 setup?
Date: Thu, 3 Feb 2011 14:07:10 -0200
Message-ID: <AANLkTim7E9QBv0PYmFLdu9Jkri+JKn8emwrkZPgfoeaE@mail.gmail.com>
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
ok,  i think that there=B4s no 'better' layout for ssd since ssd don=B4=
t
have a variable access time like head on hard disk
it=B4s better because today read balance is optimized for minimal
distance (nearest head)
but it=B4s not true that layout for ssd is better

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

no, it=B4s not a elevator, it=B4s a raid1 read balance, based on time
(each sda,sdb,sdc,sdd can have you elevator without problem) it=B4s lik=
e
a elevator for raid1 (mirror), some other raid could use it too
(raid10, i don=B4t know if raid5 have mirror, but if yes, could use too=
)

>
> best regards
> keld
thanks, keld

--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
