Received: from sonic305-2.consmr.mail.bf2.yahoo.com (sonic305-2.consmr.mail.bf2.yahoo.com [74.6.133.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AEC71D542
	for <linux-raid@vger.kernel.org>; Fri, 26 Jan 2024 16:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.6.133.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706285103; cv=none; b=coBf+QaCp87IBZ1HYM337X0jBBBJdBp038o4RKA9ccA1J9eEnPRFJJCpZsIE/01Qqp0X/aeH224WwkeghxFSDas2KdlUYDzAynbry7gU+dGbnTTpTGHpwsv25stcSuUzxyuAR4agFRaXnvvjlaF+olK1Uh0QfFRDXxK5T2Vze04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706285103; c=relaxed/simple;
	bh=HPqGr3q+z38kPDOmZbfpICrPKuV1tKYSq+78hb6dg+w=;
	h=Date:From:To:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=h6jNqsLxbYN5sFm3l88nRD8v5CwmS2UM3MuOmGj9QiUzv/SYX9TBiPecHPVM/B8M/zkIlta2QnAj6/bJ/u0fWMk66pJVg1oQ3yVfwFRh3UnD8v2vV0u5QnUq9X/rj+ofqDVVjmLuG/ryIzZfPmyjGew4UU0hDi9UssSAfZYQ8Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=OxJm+y9X; arc=none smtp.client-ip=74.6.133.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="OxJm+y9X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1706285099; bh=HPqGr3q+z38kPDOmZbfpICrPKuV1tKYSq+78hb6dg+w=; h=Date:From:To:In-Reply-To:References:Subject:From:Subject:Reply-To; b=OxJm+y9XxvgoXO1HDx/JU6ZKOwHlzEqJJg3IlORntRPD2WwtRpAwJ+3XDrxcPQ39XyQCk6Zo+yUWtsWYdDYXPX79AKj9RiAXoW2tKL49sa58henvopOlJD5N4E2ilpZT4LRYajaFlI8Y91vgmSe8RpEbK2y7ZrIw5ZQ4LfChbn1pcgCvTNtpxjKBemIXLCJQHDcIL5ixFEgCghMilj9uoMGdxl8O72g7BSUX/bXKAzmmw7kPpkO2T3aNmJd29T2tbFnyHzPoyrARjsoTZ5gO2MF1TpQPuAx4pNbzyMB11uyl8wP+5uw41zCiiAPLDQqmoAYSdAGssoMkUSpqEonvQw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1706285099; bh=SRIt69QMinoh0GLPTP1U+Enz8Lh2bNyj7G6HTwOKhJG=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=FGKW8UYSaakJMtsm45vWhiq6cm4fAimQZh868JFkTSL28BKGrGeF2q5LlARdG2vWBQYXG5UmwiaE4Rt+t8sgDgXQsMnrOYsRRkABY/1sTEL4zF4dSN/8SayrvXZ0afYpBchGK/AMibkWk+PR1QO7IIS+dMbl9/CupSA/3RG9JPU2Ecx0oNgazcae7dshLKT6E7lPriD589tzjQi4wHPaesUx/kss1AK/uIXunx4F7RJSf3fq0KFwiXZ/y2kDaibTnFQvF3rCP2BXxvK99Yu/OPPEavuyuuXwKRIC+BJCkBJOVzqPqivur1sXth6MmjPky8Fy4qUmK6xaGtuPzqMPXw==
X-YMail-OSG: j4NLha8VM1lYt8S184yx8txGQRTh5XuWLeyMRiBDpj94a0MHkm91mQlPFr5NgHA
 79zimKjhZSY5PvHnPmYGlsF7isZhO4QX5Xl7euQyIVBNQ51InIne4LJFInI4tCXKiBJmsJWNA6bf
 Z63ez2FATxuLYMfHyCz4w2s4mEguc.UG6TUKgCAj0D80GQP24gQFf5MNT2UL5orOc8XTaq3OVp7g
 AsLdf0cZmHL9.D.K76.vMXzhghwP0YXjCsk9FdpOQsyDQpP8dMWHKbB2VnoXbWfRIhYnvxxHgcLF
 TCpWQJM9EE0cZomjs6.K5POwQfRjMALcQGDCdH4nO.4BTOr6waC8dhBf5qD0GQPluQhYJ8nEydh3
 loQX6jajlHLuz1AMWZVMtpVRdpMNKl820DraCXGCasofkcWLEDWSOReBkZsGrS7kPngCyzytfTzq
 sLAaJfYdoZdCyVGIs8O2C9zKkZHhnueu6SPAcvqL_AvbOX.aaZOBl6pqxa1pE3YxXR86CcHwzu8n
 XpnNbu6Lp1tJlYlK51hYWQKISZ26kOE0sZ3eewT3CKTjDGr7L95pMiBfewS.nAOzJiLCEMwkQnQn
 wlepbzzBerH6zs8wCt4IbZKtMkcydo7pVH1cxN9iOuLP8rgnkC5k5hN4wNJciPmYlzlTU43Figg_
 pecl6NjUW0wotwo_CXx3f18oDUY4iX2zUEyCGnBPofAAIzfoGy8IwkBrn2CyhITMCvyrgAv2EHci
 _RL5n9BJowdNrsotRpqZ_BV3aJIfVRtxS8f2c21KUkv.DkbluZS19VHeG19FdaauebWJ2kQqESsY
 rfv0YaKzJe7gtpdCfWBnmrWKDeCsDCYeBtOZZ4xpSffh888o26ai_xEV.J5YJgVXhSK8xYasjGIC
 zTWyMApS7rvE2.igXN_4TtJVpJa50oyoQuCbSm6e_QEG7HrDKPIgXS3O59QswuLKy991qYvGk9L3
 gcwWmDZvCkNpSWxATnrUI7Ikv2Ny9yGxnJG1hS_rNLiSk.WOYUP3T9vulBNKMckf1YqaZuzNR0Gi
 ToVHt5n76G51u2nOFHRKYATXr16ODtMyNDND9NzEaw4rC2IJRNbGrQpi8Da5mD1vLorjbiMUsjsU
 W2LkRFSCdJsUEcW4aC3RW.sWSLIF4TLrv7DJVq0jc7IJHafzUSun6st9IHjKtuYQ457.Tb3fzv0L
 8Fe6AEU822NeDjx6ieF3Xw364lt20OQlZTHEsK_1TEYjpDHG.M.DWfX2uWOsizubyTm0jHmh7xKT
 6eL2BPkdlsnXaYYsqyOaXtxSAJXY.7YrED3xxl3VYSpIPUnw8DXnmzCc6DcpvoP8VCoJO82nrHdJ
 M0SAn9hOJgcYYMbYqmWDBEQNhA6C.enWijEdYG4EIZ42N4LlQDvfuWkGv0By3j5ThzTp4qFzajJA
 snLyG3jU0QsrTVatxufJwJKqBgyorrkzso54MTVvQX1NboJ8q3qQveugY1wFerQoFu16OjGl0UQt
 p7fPBEICNnko5rbF3r6MDYdpz7aarGcHuBJKwdXUNnLx_IgHerjGUP9Rh4sDHcWu0SJZFjsGlbiR
 XxErmX4mKH42S.1ootm9QrL1qilXTP9jmLrgbM.Rj5cWiuk0SAh6JR242VQXdprzyT.WsFL3iX9c
 jd49PY7.jjGDWk5ReU5KPiULzBprByfViZLl9cJDaMvBzeWB9aOBYv1K5j47HF7sV560iEIEr03.
 C3HBBwlbqtqqovRTPRjEsfpBdpuTeyMGWmahxPiyJntXYz0ycUAK6N2NeZLtja_bJ1F02KHgeOfz
 8pbBuafOKZBlEYeCs9zXHUGXX4UixsjwWApD8u7jd2oEi061xIcv8pp4lLIXZX6v6wO53D8brcV4
 ppLxP9tIAmXBC.eDjV5sVhsP03b09kixhrhQqadz44hOZ0AXVPWDECI..gNJig2fqnU32KD6n8aQ
 9US5YJuL_QPtLEdkefNaVIsLqV2C52gO4zWpkPqU0HEizIn2C6CrBFZ5Mgy1IwcneevJ9_hDYGYk
 E4821hkCS4PLPw6WFWxb_1KuVWTsFI.8W29BaKiuoz_fCMaSSTCwHOIc6xFLFO5cMkRHxZ6XKfIQ
 CYaCDjDpTn1v6LrOwsAReDJ3WE9zDH4tYXC.yChIOuNzJbsWw_4E5ik3g6_tpacSELpqM0j1Vigo
 38bsh4f1Cr.xPZ2INYYbqXhVgieNELHxOD6ef7PYeHS2icRpBWh9fpXZFyj1khmbQUHemraP9fw-
 -
X-Sonic-MF: <rjm1@yahoo.com>
X-Sonic-ID: afe7f3c1-c1e8-4d12-9c8c-06e253c0b1c7
Received: from sonic.gate.mail.ne1.yahoo.com by sonic305.consmr.mail.bf2.yahoo.com with HTTP; Fri, 26 Jan 2024 16:04:59 +0000
Date: Fri, 26 Jan 2024 16:03:38 +0000 (UTC)
From: RJ Marquette <rjm1@yahoo.com>
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Message-ID: <277668438.720791.1706285018378@mail.yahoo.com>
In-Reply-To: <394943768.706124.1706282116746@mail.yahoo.com>
References: <432300551.863689.1705953121879.ref@mail.yahoo.com> <04757cef-9edf-449a-93ab-a0534a821dc6@thelounge.net> <1085291040.906901.1705961588972@mail.yahoo.com> <0f28b23e-54f2-49ed-9149-87dbe3cffb30@thelounge.net> <598555968.936049.1705968542252@mail.yahoo.com> <755754794.951974.1705974751281@mail.yahoo.com> <20240123110624.1b625180@firefly> <12445908.1094378.1706026572835@mail.yahoo.com> <20240123221935.683eb1eb@firefly> <1979173383.106122.1706098632056@mail.yahoo.com> <006fe0ca-a2fb-4ccd-b4d4-c01945d72661@penguinpee.nl> <2058198167.201827.1706119581305@mail.yahoo.com> <CAAMCDef52pGpqOpOFRW8LAyiXtaJNzDderb7KLx8GR0BqP2epg@mail.gmail.com> <544664840.269616.1706131905741@mail.yahoo.com> <CAAMCDecCCCH9oOtx08g-yLwo_8JCHMkyUKu-f91du7O40wy+EA@mail.gmail.com> <5112393.323817.1706145196938@mail.yahoo.com> <CAAMCDefBd2qToWacy9HTs8UmimVi6eKgADg=BN7RkCnfE7Cirg@mail.gmail.com> <efa91e20-0c84-4652-8652-94270c63a52d@plouf.fr.eu.org> <1822211334.391999.1706183367969@mail.yahoo.com> <1700056512.428301.1706195329259@mail.yahoo.com> <CAAMCDefTxHVRNbhfyGuaoGXLs0=jKdLgd-rSdCXMpiBgYM-4iQ@mail.gmail.com> <1421467972.497057.1706207603224@mail.yahoo.com> <CAAMCDedT1-ar56AQNKPX4xoHGEh4A3o7jHU6PBratxUKPDhv7g@mail.gmail.com> <CAAMCDef11MgVfeH07T+CNu9AE8hZ6fHiMh=Zdr7BQXD_CDwMwg@mail.gmail.com> <CAAMCDefv8XuxJqDOCQV+u80TT+Jnr8fVik+vzhc7NWy+NPU=Cw@mail.gmail.com> <394943768.706124.1706282116746@mail.yahoo.com>
Subject: Re: Requesting help recovering my array
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Mailer: WebService/1.1.22046 YMailNorrin

HOLY...=C2=A0 I GOT IT!=C2=A0 WOW.

I guess all I needed to do was abandon hope.

The magic spell that worked (sorry, I know it's not magic to the developers=
 on this list, but it definitely feels that way to me right now):

mdadm --create /dev/md0 --level=3D5 --chunk=3D512K --data-offset=3D262144s =
--raid-devices=3D5 /dev/sde /dev/sdf /dev/sdg /dev/sda /dev/sdb --assume-cl=
ean --readonly

I'm copying the stuff I thought I lost now, while it's still accessible in =
RO mode!

The previous command I tried swapped sdb and sda, and I got a different err=
or when I tried to mount it.=C2=A0 The previous attempts all gave me the "b=
ad superblock" error upon mount attempt, but that attempt said something li=
ke filesystem errors.=C2=A0 So I made a note of it, then tried the one abov=
e, and it mounted cleanly.=C2=A0 No concerns at all.

(Sorry, I'm sure this is normally a very stoic list, but, I'm sure you unde=
rstand my excitement here.)

I assume, once I'm comfortable with my backups, I can unmount it, stop it, =
then use mdadm --assemble to load it again with read/write access. I've alr=
eady updated the mdadm.conf with the new uuid, so I think it should work au=
tomatically then.

Yes, I will review my backup plan and make improvements.=C2=A0 The plan was=
 good, in that I wasn't going to lose most of the critical stuff, but not g=
reat, in that I was going to lose some.

(And, yes, I still wonder why it happened in the first place, so I will kee=
p that in mind.=C2=A0 My guess is that if the array survives the next reboo=
t, it'll probably be fine for a long time.=C2=A0 If it doesn't, then it's c=
learly something in the motherboard trashing it.=C2=A0 Not great, but at le=
ast now I'll know how to resurrect it when I swap in the previous motherboa=
rd.)

THANK YOU EVERYONE!

--RJ




On Friday, January 26, 2024 at 10:15:16 AM EST, RJ Marquette <rjm1@yahoo.co=
m> wrote:=20





Thanks.

I'm not following all of what you're saying, and I suspect I'm beyond the p=
oint where it's going to help.=C2=A0 I tried the instructions on the page y=
ou linked, but I haven't hit the right combination of parameters and drive =
order to get a valid ext4 partition.=C2=A0 Sigh.=C2=A0 I will admit I could=
n't get the overlay working, and figuring I was already likely not going to=
 be able to recreate it, I went for it directly on the drives - still using=
 readonly and assume clean, but of course it overwrites what was left of th=
e partition tables - which I figured was no big loss at this point.=C2=A0 I=
t didn't sound like my chances of recovery were very high anyway.

Basically I'm trying variations on this command - removing offset, using sd=
[x] instead of sd[x]1, changing the order of a and b, etc.=C2=A0 Would it b=
e critical the spare drive be included?=C2=A0 I can't see why it would, so =
I've been ignoring it during these tests.=C2=A0 (The chunk and offset came =
from the info on the spare drive.)

mdadm --create /dev/md0 --level=3D5 --chunk=3D512K --data-offset=3D262144s =
--raid-devices=3D5 /dev/sda1 /dev/sdb1 /dev/sde1 /dev/sdf1 /dev/sdg1 --assu=
me-clean --readonly

I really do wish I knew what happened to these drives (and I'm sure this gr=
oup would, too).=C2=A0 I'm pretty sure it was something in the BIOS that ca=
used it; I've seen a few reports of motherboards from this era (~2015) with=
 bugs in UEFI in other brands that caused issues like this, but I couldn't =
find anything specific to ASUS.=C2=A0 Someone mentioned the possibility of =
something happening while it was running that would have cropped up when I =
rebooted (even on the old board), but it hadn't been that long since my pre=
vious reboot (~30 days IIRC), and as I mentioned I've had no cause to modif=
y anything related to the system, aside from updating the software using ap=
t.

After I recreate the array, I'll throw some data on it, and then reboot the=
 computer to see what happens.=C2=A0 It'll probably be fine, but if it's mu=
nged again...well...that will certainly be an interesting outcome, to say t=
he least.

Thanks for the suggestions, everyone.=C2=A0 I'm not planning to overwrite t=
he array right this moment, so if you have other suggestions on things to t=
ry, I'm open to them.

Other thoughts as I process this:

I dunno.=C2=A0 At one point a few weeks ago, my /var partition (which isn't=
 on the array) filled up, so that caused some weird issues with various thi=
ngs until I figured out what was going on.=C2=A0 I doubt that was a factor =
here, and the array was working just fine after the cleanup.

I do have backups of most of the stuff that was on the array - I will lose =
a bunch of our ripped DVDs and Blu-Rays, which is a headache to recreate, b=
ut not truly lost.=C2=A0 I believe I have copies of all of our recent pictu=
res on my laptop or desktop machine; older stuff is stored on Amazon Glacie=
r, if needed, but I think I have a local copy of most of it.=C2=A0=C2=A0

I see a few groups of pictures I may have lost completely.=C2=A0 They were =
too new for being uploaded to Glacier, but too old to still be on my deskto=
p or laptop.=C2=A0 I don't seem to have posted them online, either.=C2=A0 (=
I'm checking my Glacier inventory now to see if I did upload them at some p=
oint, but it's unlikely.)

I did lose some data for a hobby project, which is not at all critical or i=
mportant in the grand scheme of things, but it is a bummer.=C2=A0 I've even=
 been thinking about how I should back up that data.=C2=A0 Fortunately, I a=
lways enter the most important information into a database when new data ca=
me in, so I at least have that.

I used to have a script that backed up the array to a 3TB drive in my deskt=
op machine, but as 7TB (used space in the array) is greater than 3TB, there=
 was an obvious issue developing, so I stopped it a few years back, instead=
 of paring down the stuff copied over.=C2=A0 Dang.

Thanks.
--RJ





On Thursday, January 25, 2024 at 06:01:18 PM EST, Roger Heflin <rogerheflin=
@gmail.com> wrote:=20





looking further gpt may simply clear all it could use.

So you may need to look at the first 16k and clear on the overlay that
16k before the test.

On Thu, Jan 25, 2024 at 4:53=E2=80=AFPM Roger Heflin <rogerheflin@gmail.com=
> wrote:
>
> and given the partition table probably eliminated the disk superblocks
> step #1 would be to overlay sdX (not sdx1) and remove the partition
> from the overlay and begin testing.
>
> The first test may be simply the dd if=3D/dev/zero of=3Doverlaydisk bs=3D=
256
> count=3D8 as looking at the gpt partitions I have says that will
> eliminate that header and then try an --examine and see if that finds
> anything, if that works you won't need to go into the assume clean
> stuff which simplifies everything.
>
> My checking says the gpt partition table seems to start 256bytes in
> and stops before about 2k in before hex 1000(4k) where the md header
> seems to be located on mine.
>
>
>
> On Thu, Jan 25, 2024 at 4:37=E2=80=AFPM Roger Heflin <rogerheflin@gmail.c=
om> wrote:
> >
> > If the one that is working right does not have a partition then
> > someway the partitioning got added teh the broken disks.=C2=A0 The
> > partition is a gpt partition which another indicated is about 16k
> > which would mean it overwrote the md header at 4k, and that header
> > being overwritten would cause the disk to no longer be raid members.
> >
> > The create must have the disks in the correct order and with the
> > correct parameters,=C2=A0 =C2=A0 Doing a random create with a random or=
der is
> > unlikely to work, and may well make things unrecoverable.
> >
> > I believe there are instructions on some page about md repairing that
> > talks about using overlays.=C2=A0 Using the overlays lets you create an
> > overlay such that the underlying devices aren't written to such that
> > you can test a number of different orders and parameters to find the
> > one that works.
> >
> > I think this is the stuff about recovering and overlays that you want t=
o follow.
> >
> > https://raid.wiki.kernel.org/index.php/Irreversible_mdadm_failure_recov=
ery
> >
> >
> > On Thu, Jan 25, 2024 at 12:41=E2=80=AFPM RJ Marquette <rjm1@yahoo.com> =
wrote:
> > >
> > > No, this system does not have any other OS's installed on it, Debian =
Linux only, as it's my server.
> > >
> > > No, the three drives remained connected to the extra controller card =
and were never removed from that card - I just pulled the card out of the c=
ase with the connections intact, and swung it off to the side.=C2=A0 In fac=
t they still haven't been removed.
> > >
> > > I don't understand the partitions comment, as 5 of the 6 drives do ap=
pear to have separate partitions for the data, and the one that doesn't is =
the only that seems to be responding normally.=C2=A0 I guess the theory is =
that whatever damaged the partition tables wrote a single primary partition=
 to the drive in the process?
> > >
> > > I do not know what caused this problem.=C2=A0 I've had no reason to r=
un fdisk or any similar utility on that computer in years.=C2=A0 I know we =
want to figure out why this happened, but I'd also like to recover my RAID,=
 if possible.
> > >
> > > What are my options at this point?=C2=A0 Should I try something like =
this?=C2=A0 (This is for someone's RAID1 setup, obviously the level and dri=
ves would change for me.):
> > >
> > > mdadm --create --assume-clean --level=3D1 --raid-devices=3D2 /dev/md0=
 /dev/sda /dev/sdb
> > >
> > > That's from this page:=C2=A0 https://askubuntu.com/questions/1254561/=
md-raid-superblock-gets-deleted
> > >
> > > I'm currently running testdisk on one of the affected drives to see w=
hat that turns up.
> > >
> > > Thanks.
> > > --RJ
> > >
> > > On Thursday, January 25, 2024 at 12:43:58 PM EST, Roger Heflin <roger=
heflin@gmail.com> wrote:
> > >
> > >
> > >
> > >
> > >
> > > You never booted windows or any other non-linux boot image that might
> > > have decided to "fix" the disk's missing partition tables?
> > >
> > > And when messing with the install did you move the disks around so
> > > that some of the disk could have been on the intel controller with
> > > raid set at different times?
> > >
> > > That specific model of marvell controller does not list support raid,
> > > but other models in the same family do, so it may also have an option
> > > in the bios that "fixes" the partition table.
> > >
> > > Any number of id10t's writing tools may have wrongly decided that a
> > > disk without a partition table needs to be fixed.=C2=A0 I know the wi=
ndows
> > > disk management used to (may still) complain about no partitions and
> > > prompt to "fix" it.
> > >
> > > I always run partitions on everything.=C2=A0 I have had the partition=
 save
> > > me when 2 different vendors hardware raid controllers lost their
> > > config (random crash, freaked on on fw upgrade) and when the config
> > > was recreated seem to "helpfully" clear a few kb at the front of the
> > > disk.=C2=A0 Rescue boot, repartition, mount os lv, and reinstall grub
> > > fixed those.
> > >
> > > On Thu, Jan 25, 2024 at 9:17=E2=80=AFAM RJ Marquette <rjm1@yahoo.com>=
 wrote:
> > > >
> > > > It's an ext4 RAID5 array.=C2=A0 No LVM, LUKS, etc.
> > > >
> > > > You make a good point about the BIOS explanation - it seems to have=
 affected only the 5 RAID drives that had data on them, not the spare, nor =
the other system drive (and the latter two are both connected to the mother=
board).=C2=A0 How would it have decided to grab exactly those 5?
> > > >
> > > > Thanks.
> > > > --RJ
> > > >
> > > >
> > > > On Thursday, January 25, 2024 at 10:01:40 AM EST, Pascal Hambourg <=
pascal@plouf.fr.eu.org> wrote:
> > > >
> > > >
> > > >
> > > >
> > > >
> > > > On 25/01/2024 at 12:49, RJ Marquette wrote:
> > > > > root@jackie:/home/rj# /sbin/fdisk -l /dev/sdb
> > > > > Disk /dev/sdb: 2.73 TiB, 3000592982016 bytes, 5860533168 sectors
> > > > > Disk model: Hitachi HUS72403
> > > > > Units: sectors of 1 * 512 =3D 512 bytes
> > > > > Sector size (logical/physical): 512 bytes / 4096 bytes
> > > > > I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> > > > > Disklabel type: gpt
> > > > > Disk identifier: AF5DC5DE-1404-4F4F-85AF-B5574CD9C627
> > > > >
> > > > > Device=C2=A0 =C2=A0 Start=C2=A0 =C2=A0 =C2=A0 =C2=A0 End=C2=A0 =
=C2=A0 Sectors=C2=A0 Size Type
> > > > > /dev/sdb1=C2=A0 2048 5860532223 5860530176=C2=A0 2.7T Microsoft b=
asic data
> > > > >
> > > > > root@jackie:/home/rj# cat /sys/block/sdb/sdb1/start
> > > > > 2048
> > > > > root@jackie:/home/rj# cat /sys/block/sdb/sdb1/size
> > > > > 5860530176
> > > >
> > > > The partition geometry looks correct, with standard alignment.
> > > > And the kernel view of the partition matches the partition table.
> > > > The partition type "Microsoft basic data" is neither "Linux RAID" n=
or
> > > > the default type "Linux flesystem" set by usual GNU/Linux partition=
ing
> > > > tools such as fdisk, parted and gdisk so it seems unlikely that the
> > > > partition was created with one of these tools.
> > > >
> > > >
> > > > >>> It looks like this is what happened after all.=C2=A0 I searched=
 for "MBR
> > > > >>> Magic aa55" and found someone else with the same issue long ago=
:
> > > > >>> https://serverfault.com/questions/580761/is-mdadm-raid-toast=C2=
=A0 Looks like
> > > > >>> his was caused by a RAID configuration option in BIOS.=C2=A0 I =
recall seeing
> > > > >>> that on mine; I must have activated it by accident when setting=
 the boot
> > > > >>> drive or something.
> > > >
> > > >
> > > > I am a bit suspicious about this cause for two reasons:
> > > > - sde, sdf and sdg are affected even though they are connected to t=
he
> > > > add-on Marvell SATA controller card which is supposed to be outside=
 the
> > > > motherboard RAID scope;
> > > > - sdc is not affected even though it is connected to the onboard In=
tel
> > > > SATA controller.
> > > >
> > > > What was contents type of the RAID array ? LVM, LUKS, plain filesys=
tem ?
> > > >
> > >
