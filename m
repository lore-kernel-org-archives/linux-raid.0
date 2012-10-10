From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: task xfssyncd blocked while raid5 was in recovery
Date: Wed, 10 Oct 2012 06:54:19 -0500
Message-ID: <507561EB.1050308@hardwarefreak.com>
References: <CACY-59dr2Gy5XgddD01yy+c5ktCgYvOdU9w-VX8GK27bvbbgRA@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACY-59dr2Gy5XgddD01yy+c5ktCgYvOdU9w-VX8GK27bvbbgRA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: GuoZhong Han <hanguozhong@meganovo.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/9/2012 10:14 PM, GuoZhong Han wrote:

> Recently, a problem has troubled me for a long time.
>=20
> I created a 4*2T (sda, sdb, sdc, sdd) raid5 with XFS file system, 128=
K
> chuck size and 2048 strip_cache_size. The mdadm 3.2.2, kernel 2.6.38
> and mkfs.xfs 3.1.1 were used. When the raid5 was in recovery and the
> schedule reached 47%, I/O errors occurred in sdb. The following was
> the output:

> ata2: translated ATA stat/err 0x41/04 to SCSI SK/ASC/ASCQ 0xb/00/00
>=20
> ata2: status=3D0x41 { DriveReady Error }
>=20
> ata2: error=3D0x04 { DriveStatusError }
<snip repeated log entries>


> end_request: I/O error, dev sdb, sector 1867304064

Run smartctl and post this section:
"Vendor Specific SMART Attributes with Thresholds"

The drive that is sdb may or may not be bad.  smartctl may tell you
(us).  If the drive is not bad you'll need to force relocation of this
bad sector to a spare.  If you don't know how we can assist.

> INFO: task xfssyncd/md127:1058 blocked for more than 120 seconds.

> The output said =93INFO: task xfssyncd/md127:1058 blocked for more th=
an
> 120 seconds=94. What did that mean?

Precisely what it says.  It doesn't tell you WHY it was blocked, as it
can't know.  The fact that your md array was in recovery and having
problems with one of the member drives is a good reason for xfssyncd to
block.

>      The state of the raid5 was =93PENDING=94. I had never seen such =
a
> state of raid5 before. After that, I wrote a program to access the
> raid5, there was no response any more. Then I used =93ps aux| task
> xfssyncd=94 to see the state of =93xfssyncd=94. Unfortunately, there =
was no
> response yet. Then I tried =93ps aux=94. There were outputs, but the
> program could exit with =93Ctrl+d=94 or =93Ctrl+z=94. And when I test=
ed the
> write performance for raid5, I/O errors often occurred. I did not kno=
w
> why this I/O errors occurred so frequently.
>=20
>      What was the problem? Can any one help me?

It looks like drive sdb is bad or going bad.  smartctl output or
additional testing should confirm this.

Also, your "XFS...blocked for 120s" error reminds me there are some
known bugs in XFS kernel 2.6.38 which cause a similar error, but are no=
t
the cause of your error.  Yours is a drive problem.  Nonetheless, there
have been dozens of XFS bugs fixed since 2.6.38 and I recommend you
upgrade to kernel 3.2.31 or 3.4.13 if you roll your own kernels.  If yo=
u
use distro kernels get the latest 3.x series in the repos.

--=20
Stan

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
