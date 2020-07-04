From: hpa@zytor.com
Subject: Re: [PATCH 09/16] initrd: remove the BLKFLSBUF call in handle_initrd
Date: Fri, 03 Jul 2020 19:19:22 -0700
Message-ID: <54AE9966-852F-4F42-A720-8D6053F0EF52@zytor.com>
References: <20200615125323.930983-1-hch@lst.de> <20200615125323.930983-10-hch@lst.de> <514b0176-d235-f640-b278-9a7d49af356f@zytor.com> <e60b1977-2e1d-75ee-e934-207658145098@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e60b1977-2e1d-75ee-e934-207658145098@youngman.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: antlists <antlists@youngman.org.uk>, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Cc: Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

On July 3, 2020 5:18:48 PM PDT, antlists <antlists@youngman=2Eorg=2Euk> wro=
te:
>On 03/07/2020 04:40, H=2E Peter Anvin wrote:
>> On 2020-06-15 05:53, Christoph Hellwig wrote:
>>> BLKFLSBUF used to be overloaded for the ramdisk driver to free the
>whole
>>> ramdisk, which was completely different behavior compared to all
>other
>>> drivers=2E  But this magic overload got removed in commit ff26956875c2
>>> ("brd: remove support for BLKFLSBUF"), so this call is entirely
>>> pointless now=2E
>>>
>>> Signed-off-by: Christoph Hellwig <hch@lst=2Ede>
>>=20
>> Does *anyone* use initrd as opposed to initramfs anymore? It would
>seem
>> like a good candidate for deprecation/removal=2E
>>=20
>Reading the gentoo mailing list, it seems there's a fair few people who
>
>don't use initramfs=2E I get the impression they don't use initrd either,
>
>though=2E
>
>I don't know too much about booting without an initramfs - I switched=20
>ages ago - so what is possible and what they're actually doing, I don't
>
>know=2E
>
>Cheers,
>Wol

Not using any init userspace at all is an entirely different issue=2E
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
