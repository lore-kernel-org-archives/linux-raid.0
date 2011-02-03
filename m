From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: What's the typical RAID10 setup?
Date: Thu, 3 Feb 2011 12:35:52 -0200
Message-ID: <AANLkTikzNHJFDfXbQEduu3=OwoaSwVp+p186K5rW1AXH@mail.gmail.com>
References: <AANLkTikvXk0gyXz6MBvhyzxXatk0FVeASPr8R8+74c_i@mail.gmail.com>
	<AANLkTinGSNmp6yUNfb9thnr3zKFTzw=fUFm+Gef3DAHw@mail.gmail.com>
	<AANLkTim_uQ7AQs_ZSyeYPJPYSLCJd6ChzzTBwBNk2qA9@mail.gmail.com>
	<20110131192858.GD27952@www2.open-std.org>
	<4D4718E1.9040607@hardwarefreak.com>
	<20110131203725.GB2283@www2.open-std.org>
	<AANLkTimxCkxkg6xuz8FgFf0=u4KY=0M=6+afnxLzT+Tu@mail.gmail.com>
	<AANLkTi=+rPzaNTKAjB=QUEGsbUcwfN8uijm96DoY_4FA@mail.gmail.com>
	<AANLkTinM6FkJtxL8dNpoy-haGqNsZVfLDwmvZcshTEYQ@mail.gmail.com>
	<AANLkTi=kUGc8bjisn69BEEkZr6kcHUyfKnVZzNtgaJf3@mail.gmail.com>
	<20110131225235.GA11775@www2.open-std.org>
	<ii8lcv$3jg$1@dough.gmane.org>
	<AANLkTin1MPYZGMuL75c=_q+ndeiz0F5+eCRudpDdTwu9@mail.gmail.com>
	<ii96gl$vrl$1@dough.gmane.org>
	<AANLkTim3UgP0jtM6E_-3o-_OuNw6j1JG8OZzcvxt8A8s@mail.gmail.com>
	<AANLkTikehWC6-wzWE26p0n7Ng1YW6Sv_L1xU_K4LZdkv@mail.gmail.com>
	<AANLkTikerSZfhMbkEvGBVyLB=wHDSHLWszoEz5As5Hi4@mail.gmail.com>
	<AANLkTikLyR206x4aMy+veNkWPV67uF9r5dZKGqXJUEqN@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikLyR206x4aMy+veNkWPV67uF9r5dZKGqXJUEqN@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew <drew.kay@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

=3D] i think that we can end discussion and conclude that context (test
/ production) allow or don't allow lucky on probability, what's lucky?
for production, lucky =3D poor disk, for production we don't allow
failed disks, we have smart to predict, and when a disk fail we change
many disks to prevent another disk fail

could we update our raid wiki with some informations about this discuss=
ion?

2011/2/3 Drew <drew.kay@gmail.com>:
>> for test, raid1 and after raid0 have better probability to don't sto=
p
>> raid10, but it's a probability... don't believe in lucky, since it's
>> just for test, not production, it doesn't matter...
>>
>> what i whould implement? for production? anyone, if a disk fail, all
>> array should be replaced (if without money replace disk with small
>> life)
>
> A lot of this discussion about failure rates and probabilities is
> academic. There are assumptions about each disk having it's own
> independent failure probability, which if that can not be predicted
> must be assumed to be 50%. =A0At the end of the day I agree that when
> the first disk fails the RAID is degraded and one *must* take steps t=
o
> remedy that. This discussion is more about why RAID 10 (1+0) is bette=
r
> then 0+1.
>
> On our production systems we work with our vendor to ensure the
> individual drives we get aren't from the same batch/production run,
> thereby mitigating some issues around flaws in specific batches. We
> keep spare drives on hand for all three RAID arrays, so as to minimiz=
e
> the time we're operating in a degraded state. All data on RAID arrays
> is backed up nightly to storage which is then mirrored off-site.
>
> At the end of the day our decision around what RAID type (10/5/6) to
> use was based on a balance between performance, safety, & capacity
> then on specific failure criteria. RAID 10 backs the iSCSI LUN that
> our VMware cluster uses for the individual OSes, and the data
> partition for the accounting database server. RAID 5 backs the
> partitions we store user data one. And RAID 6 backs the NASes we use
> for our backup system.
>
> RAID 10 was chosen for performance reasons. It doesn't have to
> calculate parity on every write so for the OS & database, which do a
> lot of small reads & writes, it's faster. For user disks we went with
> RAID 5 because we get more space in the array at a small performance
> penalty, which is fine as the users have to access the file server
> over the LAN and the bottle neck is the pipe between the switch & the
> VM, not between the iSCSI SAN & the server. For backups we went with
> RAID 6 because the performance & storage penalties for the array were
> outweighed by the need for maximum safety.
>
>
>
> --
> Drew
>
> "Nothing in life is to be feared. It is only to be understood."
> --Marie Curie
>
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
