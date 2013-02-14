From: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Subject: Re: Best practice for large storage?
Date: Thu, 14 Feb 2013 09:33:45 -0800
Message-ID: <511D1FF9.1020502@aeoncomputing.com>
References: <24358517.18.1360862926919.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <24358517.18.1360862926919.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Roy,

Why not use ZFS on Linux? (http://www.zfsonlinux.org)

ZFS on Linux is being merged into the upcoming Lustre 2.4 parallel=20
filesystem release.

--Jeff

On 2/14/13 9:28 AM, Roy Sigurd Karlsbakk wrote:
> Hi all
>
> It seems we may need some storage for video soon. This is a 20k stude=
n college in Norway, with rather a few on media related studies. Since =
these students produce rather large amounts of raw material, typically =
to be stored during the semester, we may need some 50-100TiB, perhaps m=
ore. I have setup systems with these amounts of storage earlier on ZFS,=
 but may be using Linux MD for this project. I'm aware of the lack of c=
hecksumming, snapshots etc with Linux, but may be using it because of m=
ore Linux knowledge amongst the sysadmins here. In such a setup, I gues=
s nearline SAS drives on a SAS expander will be used, and with the amou=
nt of storage needed, I won't be using a single RAID-6 (too insecure) o=
r RAID-10 (too expensive) for the lot. In ZFS-land I used smallish VDEV=
s (~10 drives each) in a large pool.
>
>   - Would using LVM on top of RAID-6 give me something similar?
>   - If so, should I stripe the RAID sets, and again, if striping them=
, will it be as easy to add new RAID sets as we run out of space?
>
> Thanks, and best regards
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
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
------------------------------
Jeff Johnson
Co-Founder
Aeon Computing

jeff.johnson@aeoncomputing.com
www.aeoncomputing.com
t: 858-412-3810 x101   f: 858-412-3845
m: 619-204-9061

/* New Address */
4170 Morena Boulevard, Suite D - San Diego, CA 92117

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
