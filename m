From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Questions about bitrot and RAID 5/6
Date: Sun, 26 Jan 2014 21:07:36 -0700
Message-ID: <D8D412C7-DC43-4C3C-82ED-08B0885F9E43@colorremedies.com>
References: <20140121171943.GC6553@blisses.org> <52DFA01E.8000301@hesbynett.no> <78DCA4D1-9386-4BE7-894C-47EF4772C431@colorremedies.com> <52E0D060.3020508@hesbynett.no> <DE020E0C-E6EC-48E9-8D7B-09F5A65A2DF5@colorremedies.com> <52E16536.2070608@turmel.org> <30218363-7819-40A1-B647-D19C1FD90548@colorremedies.com> <52E2691E.4050701@turmel.org> <0466C42D-F51E-41D1-B220-F38EB43C1A38@colorremedies.com> <52E29CEF.7030408@turmel.org> <62EB0D79-9A50-4C50-ACBF-1C507D6F449B@colorremedies.com> <52E2AD10.5080208@turmel.org> <E222FBA0-8A1A-48EF-BEAA-BD059A8C1554@colorremedies.com> <52E2C5A3.1050803@turmel.org> <4ACB5D8F-CC0F-4CF2-96C7-03D05E40C89A@colorremedies.com> <BLU0-SMTP4400FFDF95DEEA4CD16A36198A00@phx.gbl>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU0-SMTP4400FFDF95DEEA4CD16A36198A00@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Wilson Jonathan <piercing_male@hotmail.com>
Cc: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jan 25, 2014, at 10:56 AM, Wilson Jonathan <piercing_male@hotmail.co=
m> wrote:

> On Fri, 2014-01-24 at 13:54 -0700, Chris Murphy wrote:
>> On Jan 24, 2014, at 12:57 PM, Phil Turmel <philip@turmel.org> wrote:
>>=20
>> Please define "bits lost event" and cite some reference. Google retu=
rns exactly ONE hit on that, which is this thread. If we cannot agree o=
n the units, we aren't talking about the same thing, at all, with a com=
mensurately huge misunderstanding of the problem and thus the solution.
>>=20
>> So please to not merely respond to the 2nd paragraph you disagree wi=
th. Answer the two questions above that paragraph.
>>=20
>> If the spec is "1 URE event in 1E14 bits read" that is "1 bit nonrec=
overable in 2.4E10 bits read" for a 512 byte physical sector drive, and=
 hilariously becomes far worse at "1 bit nonrecoverable in 3E9 bits rea=
d" for 4096 byte physical sector drives.
>>=20
>> A very simple misunderstanding should have a very simple corrective =
answer rather than hand waiving and giving up.
>=20
> As I understand it, its "1" error (of no determinate size) for every
> 10E14 bits read=85.

Well as I understand it the < symbol is the "less than" sign, so if the=
 rate is errors per bits, then it's less than 1 error for ever 10E14 bi=
ts read.


> The size of sectors would make no difference to the raw amount of dat=
a
> read (although it does open an interesting question of what the 10E14
> actually means, does it also include any check summing data, or is it
> purely "data") nor the fact that 1 URE statistically might happen.

It's an interesting question if "bits read" includes non-user data bits=
, such as the ECC bits. I'm also curious if there's an ATA or SCSI comm=
and that instructs the drive to hand over those 512 bytes, such as they=
 are, despite a read error, or if we're just screwed.


> The amount of data corrupted is, I would have thought, variable
> depending on what forms of checksums etc. was used and is indetermina=
ble
> without knowing the exact forms of work done on the raw data, how man=
y
> checksum values there might be for a "block" and so on, to try and
> recover a meaningful, and valid, return... it could be that just 1 bi=
t
> of data was corrupted or it could be that the entire sectors worth of
> data is garbage; it could also be that the 1 URE is in such a place t=
hat
> it causes multiple sectors to be invalid=85

I'm willing to bet dollars to donuts that every vendor has differences =
in the effectiveness of their ECC, yet all of them can detect and corre=
ct merely 1 bit in 512/4096 bytes, and actually probably quite a few mo=
re bit errors than this.



Chris Murphy

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
