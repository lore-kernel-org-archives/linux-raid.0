From: CoolCold <coolthecold@gmail.com>
Subject: Fwd: mounting component device of RAID1 with internal bitmap
Date: Fri, 2 Apr 2010 18:39:18 +0400
Message-ID: <n2mf19d625d1004020739oade0211ap1def8afa5c2d8e89@mail.gmail.com>
References: <q2zf19d625d1004011047gf9d48094p696ac38e669fb5e4@mail.gmail.com>
	 <4BB4E291.5090304@redhat.com>
	 <s2nf19d625d1004011126p80d579b7oaba81484dcad92ce@mail.gmail.com>
	 <4BB4E861.9020003@redhat.com>
	 <l2hf19d625d1004011225q850be4an64d7bcb6d5604dc7@mail.gmail.com>
	 <4BB4F548.2090709@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e659f984b7c00b048341f1be
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BB4F548.2090709@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--0016e659f984b7c00b048341f1be
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Just to share this with list.


---------- Forwarded message ----------
From: Doug Ledford <dledford@redhat.com>
Date: Thu, Apr 1, 2010 at 11:34 PM
Subject: Re: mounting component device of RAID1 with internal bitmap
To: CoolCold <coolthecold@gmail.com>


On 04/01/2010 03:25 PM, CoolCold wrote:
> On Thu, Apr 1, 2010 at 10:39 PM, Doug Ledford <dledford@redhat.com> wrote=
:
>> On 04/01/2010 02:26 PM, CoolCold wrote:
>>> On Thu, Apr 1, 2010 at 10:14 PM, Doug Ledford <dledford@redhat.com> wro=
te:
>>>> On 04/01/2010 01:47 PM, CoolCold wrote:
>>>>> Hello!
>>>>> For raid1 array with metadata 0.90 it is possible to mount component
>>>>> (let's say /dev/sda1) as usual FS, fix smth, /etc/fstab for example,
>>>>> unmount and then assamble arary.
>>>>
>>>> At which point you have just corrupted your array.
>>> I've did such operation several times and it worked fine..I'll do some
>>> checks and report later.
>>
>> Because you got lucky. =A0When you do this, you make the different membe=
rs
>> of the raid array disagree on the contents of whatever file you
>> modified. =A0Depending on which disk the kernel reads from, you will get
>> either the new or the old contents of the file. =A0Any time you mount a
>> component device and modify it, you *must* force a resync from that
>> component to all other components or you *will* have a corrupt array.
>> When that corruption will crop up to bite you in the ass is up to random
>> chance.
> Ah, ofcourse recync is ok , i wanted to know will this break _raid_
> (eg erase some metadata) itself, not actual data on top of it. For 0.9
> it is said in man that it stored at the end of device, but what about
> bitmaps? are they at the end too ?

The bitmaps are outside of the regular filesystem area, so they can't be
harmed by mounting the filesystem.


--
Doug Ledford <dledford@redhat.com>
=A0 =A0 =A0 =A0 =A0 =A0 =A0GPG KeyID: CFBFF194
=A0 =A0 =A0 =A0 =A0 =A0 =A0http://people.redhat.com/dledford

Infiniband specific RPMs available at
=A0 =A0 =A0 =A0 =A0 =A0 =A0http://people.redhat.com/dledford/Infiniband




--=20
Best regards,
[COOLCOLD-RIPN]

--0016e659f984b7c00b048341f1be
Content-Type: application/pgp-signature; name="signature.asc"
Content-Disposition: attachment; filename="signature.asc"
Content-Transfer-Encoding: base64
X-Attachment-Id: 0.1

LS0tLS1CRUdJTiBQR1AgU0lHTkFUVVJFLS0tLS0KVmVyc2lvbjogR251UEcgdjEuNC4xMCAoR05V
L0xpbnV4KQoKaUVZRUFSRUNBQVlGQWt1MDlVZ0FDZ2tRZzZXeWxNKy84WlFaRUFDZU9pUDFPODc4
bE5rcSt2dEIrVkpiQTBNcwpkaVVBbjBkb3dnTzFxWHNRZHFHZ00yUVpkOU80LzRjSwo9U2NUcgot
LS0tLUVORCBQR1AgU0lHTkFUVVJFLS0tLS0K
--0016e659f984b7c00b048341f1be--
