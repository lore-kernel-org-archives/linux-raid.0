From: Chris Murphy <lists@colorremedies.com>
Subject: Re: writing zeros to bad sector results in persistent read error
Date: Mon, 9 Jun 2014 18:09:56 -0600
Message-ID: <BBD6BB5F-9D33-413B-AD74-3DC3EA34D6AB@colorremedies.com>
References: <B7EA34DA-1064-45B1-B0C0-B7C423C7EB47@colorremedies.com> <20140607075140.277c0880@natsu> <0E76B97E-96DF-43A3-B8EC-4867964BF8E9@colorremedies.com> <BLU436-SMTP1535675BF98253D9B967F17982E0@phx.gbl>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU436-SMTP1535675BF98253D9B967F17982E0@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Wilson Jonathan <piercing_male@hotmail.com>
Cc: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jun 8, 2014, at 2:10 AM, Wilson Jonathan <piercing_male@hotmail.com>=
 wrote:

> On Sat, 2014-06-07 at 18:52 -0600, Chris Murphy wrote:
>> I wrote:
>>> How can there still be pending bad sectors, and yet no error and LB=
A reported?
>>=20
>> So I started another -t long test. And it comes up with an LBA not p=
reviously reported.
>>=20
>> # 1  Extended offline    Completed: read failure       60%      1214=
         430234064
>>=20
>> # dd if=3D/dev/zero of=3D/dev/sda seek=3D430234064 count=3D8
>> dd: writing to =91/dev/sda=92: Input/output error
>> 1+0 records in
>> 0+0 records out
>> 0 bytes (0 B) copied, 3.63342 s, 0.0 kB/s
>>=20
>> On this sector the technique fails.
>>=20
>> # dd if=3D/dev/zero of=3D/dev/sda seek=3D430234064 count=3D8 oflag=3D=
direct
>> 8+0 records in
>> 8+0 records out
>> 4096 bytes (4.1 kB) copied, 3.73824 s, 1.1 kB/s
>=20
> I may be missing something here, but surely after all this faffing ab=
out
> and errors isn't it about time to replicate the data to a new drive a=
nd
> then hit this one repeatedly with a very large hammer.
>=20
> The law of diminishing returns must surely be coming into play by now=
=2E

No the question here isn't what's the right course of action from this =
point. This is an academic question: whether the reported behavior(s) a=
re as designed.

=46rom an enterprise perspective, my understanding is even one bad sect=
or is disqualifying and the drive goes back to the manufacturer if it's=
 under warranty; or otherwise demoted for less important use if it's no=
t.

=46or consumer drives, which this is, all the manufacturers will say th=
e drive is functioning as designed with bad sectors *if* they're being =
reallocated. Maybe some of them won't quibble and will send a replaceme=
nt drive anyway.

But what I'm reporting is an instance where an ATA Secure Erase definit=
ely did not fix up a single one of the bad sectors. Maybe that's consis=
tent with the spec, I don't know, but it's not what I'd expect seeing a=
s every sector, those with an without LBA's assigned, are overwritten. =
Yet pending sectors were not remapped. Further, with all sectors overwr=
itten by software (not merely the ATA Secure Erase command) yields no e=
rrors yet SMART reports there are still pending sectors, yet it's own e=
xtended test says there are none. I think that's bad behavior. But perh=
aps I don't understand the design and it's actually working as designed=
=2E


Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
