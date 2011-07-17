From: Iustin Pop <iusty@k1024.org>
Subject: Re: standard performance (write speed 20Mb/s)
Date: Sun, 17 Jul 2011 14:22:30 +0200
Message-ID: <20110717122230.GB2614@teal.hq.k1024.org>
References: <201107162140.58883.raid1@fuckaround.org>
 <4E226464.2030200@hardwarefreak.com>
 <ac6850f9420970de26472b6a9dcc2a82.squirrel@fuckaround.org>
 <4E22D167.2010905@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4E22D167.2010905@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Pol Hallen <raid1@fuckaround.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Jul 17, 2011 at 01:11:19PM +0100, John Robinson wrote:
> On 17/07/2011 09:12, Pol Hallen wrote:
> >hello and thanks for the reply :-)
> >
> >dd if=3D/dev/zero of=3Dtest bs=3D4096 count=3D262144
> >262144+0 records in
> >262144+0 records out
> >1073741824 bytes (1.1 GB) copied, 31.3475 s, 34.3 MB/s
>=20
> Pretty poor. CentOS 5, Intel ICH10, md RAID 6 over 5 7200rpm 1TB
> drives, then LVM, then ext3:
> # dd if=3D/dev/zero of=3Dtest bs=3D4096 count=3D262144
> 262144+0 records in
> 262144+0 records out
> 1073741824 bytes (1.1 GB) copied, 2.5253 seconds, 425 MB/s
>=20
> And there's a badblocks running on another drive also on the ICH10.
>=20
> Having said that, I think mine's wrong too, I don't think my array
> can really manage that much throughput. We should both be using more
> realistic benchmarking tools like bonnie++:

Or simply pass the correct flags to dd =E2=80=94 like oflag=3Ddirect, w=
hich will
make it do non-buffered writes.

regards,
iustin
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
