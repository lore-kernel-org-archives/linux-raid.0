From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: standard performance (write speed 20Mb/s)
Date: Sun, 17 Jul 2011 13:51:11 +0100
Message-ID: <4E22DABF.1020807@anonymous.org.uk>
References: <201107162140.58883.raid1@fuckaround.org> <4E226464.2030200@hardwarefreak.com> <ac6850f9420970de26472b6a9dcc2a82.squirrel@fuckaround.org> <4E22D167.2010905@anonymous.org.uk> <20110717122230.GB2614@teal.hq.k1024.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110717122230.GB2614@teal.hq.k1024.org>
Sender: linux-raid-owner@vger.kernel.org
To: Iustin Pop <iusty@k1024.org>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 17/07/2011 13:22, Iustin Pop wrote:
> On Sun, Jul 17, 2011 at 01:11:19PM +0100, John Robinson wrote:
[...]
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
>
> Or simply pass the correct flags to dd =E2=80=94 like oflag=3Ddirect,=
 which will
> make it do non-buffered writes.

That's still not realistic:

# dd if=3D/dev/zero of=3Dtest oflag=3Ddirect bs=3D4096 count=3D262144
262144+0 records in
262144+0 records out
1073741824 bytes (1.1 GB) copied, 117.434 seconds, 9.1 MB/s

Because this time we're doing a read-modify-write for every 4K block, o=
r=20
at least a write for every 4K block. I can fix it up again to work in=20
stripe size amounts:

# dd if=3D/dev/zero of=3Dtest oflag=3Ddirect bs=3D1572864 count=3D683
683+0 records in
683+0 records out
1074266112 bytes (1.1 GB) copied, 18.3198 seconds, 58.6 MB/s

But it's still not realistic because real I/O does use buffers and=20
doesn't work in magic sizes, so we should be using a more realistic=20
benchmarking tool like bonnie++.

Cheers,

John.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
