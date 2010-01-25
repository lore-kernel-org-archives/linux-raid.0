From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Fw: Why does one get mismatches?
Date: Mon, 25 Jan 2010 18:32:31 +0100
Message-ID: <87iqaqqeds.fsf@frosties.localdomain>
References: <957236.22933.qm@web51307.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <957236.22933.qm@web51307.mail.re2.yahoo.com> (Jon Hardcastle's
	message of "Mon, 25 Jan 2010 02:52:58 -0800 (PST)")
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jon Hardcastle <jd_hardcastle@yahoo.com> writes:

> --- On Mon, 25/1/10, Goswin von Brederlow <goswin-v-b@web.de> wrote:
>
>> From: Goswin von Brederlow <goswin-v-b@web.de>
>> Subject: Re: Fw: Why does one get mismatches?
>> To: Jon@eHardcastle.com
>> Cc: "Goswin von Brederlow" <goswin-v-b@web.de>, linux-raid@vger.kern=
el.org
>> Date: Monday, 25 January, 2010, 10:37
>> Jon Hardcastle <jd_hardcastle@yahoo.com>
>> writes:
>>=20
>> > Now the array is completely dismantled and I am
>> running bad blocks on the drives but I am on the last 2 of
>> the 7 drives and I still have no leads. No bad blocks, no
>> offline uncorrectable, no pending sectors no dmesg errors no
>> nothing. I have absolutely no leads what so ever.
>> >
>> > The only thing i have left to try is a full Mem test
>> and disconnect and reseat the additional sata controllers,
>> oh and buy 7 new sata cables incase 1 is bad.
>>=20
>> The problem with badblocks is that it writes the same
>> pattern
>> everywhere. If the problem is that data gets read/written
>> to the wrong
>> block then that will not show up.
>>=20
>> Try formating each drive and run fstest [1] on it. Or some
>> other test
>> that verifies data integrity using different patterns per
>> block.
>>=20
>> MfG
>> =A0 =A0 =A0 =A0 Goswin
>>=20
>> [1] http://mrvn.homeip.net/fstest/
>>=20
>
> This is going to be a time consuming process as i'll have to remove a=
nd read from the array each drive 1 at a time then resync.=20
>
> Thanks for the link, but could a similar result be achieved with the =
-w option for badblocks? or perhaps a dd if=3D/dev/urandom? hmm scratch=
 that the urandom wont work as you need to read AND write.
>
> Just a worry as i clearly have mismatches and therefore corrupted dat=
a.

No. You obviously should use the -w option in badblocks. Doing a
read-only test is completly pointless as the raid check already tested =
a
read of every block without errors (I assume). But -w will write one
pattern on the whole disk, then read and compare. Then repeat for the
next pattern. If the disk messes up the address of blocks then that
won't be detected. E.g. I had a raid enclosure that droped a bit in the
block address every once in a while. You get really interesting
corruption with that.

MfG
        Goswin
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
