From: Phil Turmel <philip@turmel.org>
Subject: Re: 4x3TB raid5 - no autodetect
Date: Mon, 22 Oct 2012 12:14:45 -0400
Message-ID: <508570F5.9090202@turmel.org>
References: <441614417.20121022155507@oudeis.org> <508553FF.6020302@anonymous.org.uk> <123699751.20121022175600@oudeis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <123699751.20121022175600@oudeis.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?UmFpbmVyIEbDvGdlbnN0ZWlu?= <rfu@oudeis.org>
Cc: John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/22/2012 11:56 AM, Rainer F=C3=BCgenstein wrote:
>=20
> JR> In-kernel auto-assembly is only supported for metadata 0.90, and =
even=20
> JR> then the feature is deprecated. If you have your root filesystem =
on a md=20
> JR> array, use an initrd with mdadm in it to start it.
>=20
> if I understand it correctly, metadata 0.90 is not supporting drives =
>
> 2TB?

v0.9 supports drives to 4T, but there was a bug in several released
kernels that triggered above 2T.  There are also unsolvable
misidentification issues for partitioned drives where the last partitio=
n
can be confused with the whole disk.

> will in-kernel auto-assembly be supported sometimes in the future?
> this was quite a useful feature.

I'm sure Neil will pipe up if necessary, but he has been adamantly
against extending the in-kernel autoassembly code in any way.  Auto-
assembly is also incompatible with GPT partitions.

You should use v1.0 for mirrored boot partitions, and v1.2 for all othe=
r
arrays.  And use an initramfs.

I, too, squirmed when faced with the need to set up an initramfs, as I
was quite comfortable with my legacy configuration.  I'm glad I got ove=
r it.

HTH,

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
