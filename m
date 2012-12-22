From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: Disk speed comparison
Date: Sat, 22 Dec 2012 11:53:01 -0600
Message-ID: <CAAMCDec1PB8eZoF7FdHdRS5VVKFmnN+mUJwq1+9mE6HAtoxR0w@mail.gmail.com>
References: <CAAMCDed=47sKjPBkP-MW=ZZoEuk6KXn6fQJj5hVdxpEdueLrHw@mail.gmail.com>
 <19033157.9.1356198549636.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19033157.9.1356198549636.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Dec 22, 2012 at 11:49 AM, Roy Sigurd Karlsbakk
<roy@karlsbakk.net> wrote:
>> > I have an array with 6 2TB drives plus a spare. While this works
>> > well, I can from the munin graphs at
>> > http://munin.karlsbakk.net/munin/karlsbakk.net/smilla.karlsbakk.ne=
t/index.html
>> > that the WD2001FASS drives (sd[bcfg]) perform some 30% better than
>> > the Hitachi HDS723020BLA642 drives (sd[eh]). The drives are on a
>> > mixed set of controllers, so this shouldn't be relevant. Since the=
y
>> > all are specified to spin on 7200RPM, I find it wierd that the
>> > performance difference shown by the Munin graph is so big.
>> >
>> > Anyone seen something similar?
>>
>> Go the the manufacturers web sites and find the spec sheets for the
>> drivers.
>>
>> They will likely list a min speed and a max speed for how fast data =
is
>> passing under the head depending on if it is the inner or outer trac=
k.
>>
>> It basically comes down to if all is working exactly right, the numb=
er
>> of bytes passing under the head times rpm, so if one disk has a high=
er
>> bit density the rate will be larger, and this varies quite a bit fro=
m
>> disk to disk.
>
> Thanks for the replay
>
> WD2001FASS: 4x500GB platters
> HDS723020BLA642: 3x667GB platters
>
> - Shouldn't higher density normally mean higher speed?
>
> Vennlige hilsener / Best regards
>
> roy
> --
> Roy Sigurd Karlsbakk
> (+47) 98013356
> roy@karlsbakk.net
> http://blogg.karlsbakk.net/
> GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
> --
> I all pedagogikk er det essensielt at pensum presenteres intelligibel=
t. Det er et element=C3=A6rt imperativ for alle pedagoger =C3=A5 unng=C3=
=A5 eksessiv anvendelse av idiomer med xenotyp etymologi. I de fleste t=
ilfeller eksisterer adekvate og relevante synonymer p=C3=A5 norsk.

Depends...that assumes that the tracks on each manufacturers disks is
the same...the higher density platters  could have more tracks and
because of that lower date per track and lower bit rates per track.

Check what the manufacturer says on bit rates under the head.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
