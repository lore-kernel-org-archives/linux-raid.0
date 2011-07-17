From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: standard performance (write speed 20Mb/s)
Date: Sun, 17 Jul 2011 17:05:06 -0500
Message-ID: <4E235C92.8040106@hardwarefreak.com>
References: <201107162140.58883.raid1@fuckaround.org> <4E226464.2030200@hardwarefreak.com> <ac6850f9420970de26472b6a9dcc2a82.squirrel@fuckaround.org> <4E22D167.2010905@anonymous.org.uk> <20110717122230.GB2614@teal.hq.k1024.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110717122230.GB2614@teal.hq.k1024.org>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>, Pol Hallen <raid1@fuckaround.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 7/17/2011 7:22 AM, Iustin Pop wrote:
> On Sun, Jul 17, 2011 at 01:11:19PM +0100, John Robinson wrote:
>> On 17/07/2011 09:12, Pol Hallen wrote:
>>> hello and thanks for the reply :-)
>>>
>>> dd if=3D/dev/zero of=3Dtest bs=3D4096 count=3D262144
>>> 262144+0 records in
>>> 262144+0 records out
>>> 1073741824 bytes (1.1 GB) copied, 31.3475 s, 34.3 MB/s
>>
>> Pretty poor. CentOS 5, Intel ICH10, md RAID 6 over 5 7200rpm 1TB
>> drives, then LVM, then ext3:
>> # dd if=3D/dev/zero of=3Dtest bs=3D4096 count=3D262144
>> 262144+0 records in
>> 262144+0 records out
>> 1073741824 bytes (1.1 GB) copied, 2.5253 seconds, 425 MB/s
>>
>> And there's a badblocks running on another drive also on the ICH10.
>>
>> Having said that, I think mine's wrong too, I don't think my array
>> can really manage that much throughput. We should both be using more
>> realistic benchmarking tools like bonnie++:
>=20
> Or simply pass the correct flags to dd =E2=80=94 like oflag=3Ddirect,=
 which will
> make it do non-buffered writes.

I'm not sure of the reasons, but O_DIRECT doesn't work with dd quite th=
e
way one would think, at least not from a performance perspective.  On m=
y
test rig it yields an almost 10x decrease, much like using insane block
size.  It may have something to do with write barriers being enabled in
XFS on my test rig, or something similar.  This system is running
vanilla 2.6.38.6 with Debian Squeeze atop.  Using O_DIRECT with dd with
2.6.26 and 2.6.34 yielded the same dd O_DIRECT behavior in the past.

$ dd if=3D/dev/zero of=3D./test bs=3D4096 count=3D262144
262144+0 records in
262144+0 records out
1073741824 bytes (1.1 GB) copied, 15.0542 s, 71.3 MB/s

$ dd oflag=3Ddirect if=3D/dev/zero of=3D./test bs=3D4096 count=3D262144
262144+0 records in
262144+0 records out
1073741824 bytes (1.1 GB) copied, 133.888 s, 8.0 MB/s

--=20
Stan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
