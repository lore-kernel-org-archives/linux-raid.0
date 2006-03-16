From: Laurent CARON <lcaron@apartia.fr>
Subject: Re: Bitmaps & Kernel Versions
Date: Thu, 16 Mar 2006 12:56:37 +0100
Message-ID: <44195275.9010208@apartia.fr>
References: <4417DA8B.3040306@unix-scripts.info> <17431.59281.909724.299333@cse.unsw.edu.au> <20060315234333.GC25405@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060315234333.GC25405@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Luca Berra <bluca@comedia.it>
List-Id: linux-raid.ids

Luca Berra a =E9crit :
> On Wed, Mar 15, 2006 at 09:08:17PM +1100, Neil Brown wrote:
>=20
>> On Wednesday March 15, lcaron@unix-scripts.info wrote:
>>
>>> Hi,
>>>
>>> I'm planning to use bitmaps on some of our RAID1 arrays.
>>>
>>> I'm wondering how bitmaps are handeled by older kernels.
>>>
>>> Eg: I create a raid array with a bitmap under a 2.6.15 kernel.
>>>
>>> I now want to boot under 2.6.12, or even 2.4
>>>
>>>
>>> Hos is it handeled?
>>> Will it work even if this is my / partition?
>>
>>
>> On older kernel will not notice the bitmap and will behave
>> 'normally'.
>=20
> strange,
> last time i tried an older kernel would refuse to activate an md with=
 a
> bitmap on it.
> I am far from home on a business trip and i don't have kernel-sources=
 at
> hand, but i seem to remember that the kernel was very strict on the
> feature bitmap in the superblock.
>=20
> L.
>=20
I experienced the same strange behavior.

Bitmap was created on 2.6.15, tried to boot 2.6.14 and /dev/md0 was not=
=20
started :$.

Strange.....
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
