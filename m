From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: Disk speed comparison
Date: Sat, 22 Dec 2012 11:44:56 -0600
Message-ID: <CAAMCDed=47sKjPBkP-MW=ZZoEuk6KXn6fQJj5hVdxpEdueLrHw@mail.gmail.com>
References: <27374116.4.1356197991689.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <27374116.4.1356197991689.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Dec 22, 2012 at 11:39 AM, Roy Sigurd Karlsbakk
<roy@karlsbakk.net> wrote:
> Hi all
>
> I have an array with 6 2TB drives plus a spare. While this works well=
, I can from the munin graphs at http://munin.karlsbakk.net/munin/karls=
bakk.net/smilla.karlsbakk.net/index.html that the WD2001FASS drives (sd=
[bcfg]) perform some 30% better than the  Hitachi HDS723020BLA642 drive=
s (sd[eh]). The drives are on a mixed set of controllers, so this shoul=
dn't be relevant. Since they all are specified to spin on 7200RPM, I fi=
nd it wierd that the performance difference shown by the Munin graph is=
 so big.
>
> Anyone seen something similar?
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
> --

Go the the manufacturers web sites and find the spec sheets for the dri=
vers.

They will likely list a min speed and a max speed for how fast data is
passing under the head depending on if it is the inner or outer track.

It basically comes down to if all is working exactly right, the number
of bytes passing under the head times rpm, so if one disk has a higher
bit density the rate will be larger, and this varies quite a bit from
disk to disk.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
