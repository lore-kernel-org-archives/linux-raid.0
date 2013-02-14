From: Roberto Spadim <rspadim@gmail.com>
Subject: Re: Best practice for large storage?
Date: Thu, 14 Feb 2013 21:42:04 -0200
Message-ID: <CAH3kUhHG=jqKB1BdNh5YxR-TfE4Wh4-eOrGduhu2ksWtO4LJtA@mail.gmail.com>
References: <CAH3kUhGVt1iyn9tt=2-+f6H++obOGSK3x0pBBPZV8CFUXjp5yw@mail.gmail.com>
	<29597293.40.1360884193537.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <29597293.40.1360884193537.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Jeff Johnson <jeff.johnson@aeoncomputing.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

the problem is checksum? i really don't understand why the filesystem
is not the problem, and why storage is the 'key'

storage -> mdadm + harddisks / raid hardware + harddisks / network
storage + hard disks -> here the key is data integrity WITHOUT SILENT
DATA LOSS, today i only saw this on enterprise hardware raid
controlers + enterprise sas disks

lvm + filesystem -> don't have problem increasing storage -> here a
filesystem that can grow without problems is mandatory since you want
but more disks... the lvm part is to easly work with devices

any part that i forgot?

2013/2/14 Roy Sigurd Karlsbakk <roy@karlsbakk.net>:
> xfs+lvm+mdadm works, but I'm still back to my original question. I do=
n't care about what filesystem is on top, only about the storage undern=
eath. Read the original question again, please
>
> ----- Opprinnelig melding -----
>
>
>
> xfs+lvm+mdadm don`t work? too complex?
>
>
>
> 2013/2/14 Roy Sigurd Karlsbakk < roy@karlsbakk.net >
>
>
> ----- Opprinnelig melding -----
>
>> why not brtfs or xfs?
>
> Well, because btrfs isn't stable and doesn't support RAID-[56] unless=
 you're using the git tree for testing that, which is rather more unsta=
ble than the rest, and xfs is just a filesystem that needs to sit on to=
p of a raid of some kind.
>
>
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
t. Det er et element=E6rt imperativ for alle pedagoger =E5 unng=E5 ekse=
ssiv anvendelse av idiomer med xenotyp etymologi. I de fleste tilfeller=
 eksisterer adekvate og relevante synonymer p=E5 norsk.
>
>
>
>
> --
> Roberto Spadim
>
>
> --
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
t. Det er et element=E6rt imperativ for alle pedagoger =E5 unng=E5 ekse=
ssiv anvendelse av idiomer med xenotyp etymologi. I de fleste tilfeller=
 eksisterer adekvate og relevante synonymer p=E5 norsk.



--
Roberto Spadim
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
