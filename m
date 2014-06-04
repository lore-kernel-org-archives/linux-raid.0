From: Eivind Sarto <eivindsarto@gmail.com>
Subject: Re: [patch 1/1] raid0: discard requests do not align to chunk boundary
Date: Tue, 3 Jun 2014 21:51:22 -0700
Message-ID: <3F3A3793-56FF-4F64-B5FE-C056402CC080@gmail.com>
References: <4267B3A0-F0E8-407C-86D8-45ABC46D1464@gmail.com> <20140604122036.11175d7a@notabene.brown>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: multipart/mixed; boundary="Apple-Mail=_48F63083-80F1-4229-9455-8E77522F05A3"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140604122036.11175d7a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Eivind Sarto <eivindsarto@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Apple-Mail=_48F63083-80F1-4229-9455-8E77522F05A3
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

Oops.  This one.
-eivind

--Apple-Mail=_48F63083-80F1-4229-9455-8E77522F05A3
Content-Disposition: attachment;
	filename=raid0_discard_requests_do_not_align_to_chunk_boundary.patch
Content-Type: application/octet-stream;
	name="raid0_discard_requests_do_not_align_to_chunk_boundary.patch"
Content-Transfer-Encoding: 7bit

Author: Eivind Sarto <esarto@fusionio.com>
Date: Tue Jun  3 14:07:29 2014

raid0: discard requests do not align to chunk boundary

Raid0 sets max_discard_sectors equal to chunk_size.  However, that does
make blkdev_issue_discard() to issue chunk-aligned REQ_DISCARD to raid0.
If blkdev_issue_discard() is called with a non-chunk-aligned sector, it will
break the request into multiple chunk-sized bio requests, but all the bio
requests to raid0 will stay mis-aligned (and raid0 will need to split them all).

This patch sets the device queue discard granularity + alignment.
It will make blkdev_issue_discard() always break REQ_DISCARD requests into
aligned requests to raid0, after the first partial/mis-aligned request has been
issued.

Signed-off-by: Eivind Sarto <esarto@fusionio.com>

--- a/drivers/md/raid0.c	2014-06-02 11:26:29.000000000 -0700
+++ b/drivers/md/raid0.c	2014-06-03 11:56:05.000000000 -0700
@@ -440,6 +440,8 @@ static int raid0_run(struct mddev *mddev
 	blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
 	blk_queue_max_write_same_sectors(mddev->queue, mddev->chunk_sectors);
 	blk_queue_max_discard_sectors(mddev->queue, mddev->chunk_sectors);
+	mddev->queue->limits.discard_alignment = mddev->chunk_sectors << 9;
+	mddev->queue->limits.discard_granularity = mddev->chunk_sectors << 9;
 
 	/* if private is not null, we are here after takeover */
 	if (mddev->private == NULL) {

--Apple-Mail=_48F63083-80F1-4229-9455-8E77522F05A3
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii


On Jun 3, 2014, at 7:20 PM, NeilBrown <neilb@suse.de> wrote:

> On Tue, 3 Jun 2014 14:18:53 -0700 Eivind Sarto <eivindsarto@gmail.com> =
wrote:
>=20
>> Raid0 only sets max_discard_sectors, but does not force alignment of =
discard requests.  Discard request
>> will be broken up into chunk-sized REQ_DISCARD by =
blkdev_issue_discard(), but if the sector is not=20
>> chunk-aligned, each REQ_DISCARD to raid0 will all remain unaligned =
and raid0 will ned to split them all.
>>=20
>> This patch will prevent splitting of REQ_DISCARD requests.
>>=20
>> -eivind
>=20
> Which patch would that be, exactly.  :-)
>=20
> NeilBrown


--Apple-Mail=_48F63083-80F1-4229-9455-8E77522F05A3--
