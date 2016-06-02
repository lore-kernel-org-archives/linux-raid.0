From: NeilBrown <nfbrown@novell.com>
Subject: Re: Why does raid0 set max_hw_sectors as chunk size but the other raid types doesn't?
Date: Thu, 02 Jun 2016 14:38:29 +1000
Message-ID: <87lh2op5mi.fsf@notabene.neil.brown.name>
References: <CAHvN=in80JrXO=tDyxNhq9d_wW1ZCCioENyTLu9tYuYYDof20w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHvN=in80JrXO=tDyxNhq9d_wW1ZCCioENyTLu9tYuYYDof20w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joey Liao <joeyliao@qnap.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Mon, May 30 2016, Joey Liao wrote:

> Hi,
>
> I have no idea why does raid0_run() in raid0.c use
> blk_queue_max_hw_sectors() to set max_hw_sectors as the chunk size,
> but the other raid types doesn't?

git is your friend.... admittedly you need the 'history' git tree to go
back before 2.6.12, but it is available.

http://git.kernel.org/cgit/linux/kernel/git/history/history.git/commit/?id=f556ef000efc90a45a285f4f0b4fd70bb70f



>
> What's the purpose to limit the max_hw_sectors in raid0?

unfortunately the commit doesn't answer that question.  I think it was
to ensure requests larger than one chunk were not created.  If they were
they would just have to be split, so there is no much to gain.

>
> Is it related to the source code logic issue or the performance issue?
>
> Besides, I have an interesting observation. If I remove all the
> following queue limitation codes in raid0_run() of raid0.c, the block
> size in iostat is still the same as chunk size even the input block
> size is much larger than the chunk size. Why???

Because when you write to a RAID0 you *must* divide each request up into
chunk-sizes sub-requests, and send them to different devices.

NeilBrown


>
> -  blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
> -  blk_queue_max_write_same_sectors(mddev->queue, mddev->chunk_sectors);
> +  //blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
> +  //blk_queue_max_write_same_sectors(mddev->queue, mddev->chunk_sectors);
>
> -  blk_queue_io_min(mddev->queue, mddev->chunk_sectors << 9);
> -  blk_queue_io_opt(mddev->queue,
> -                 (mddev->chunk_sectors << 9) * mddev->raid_disks);
> +  //blk_queue_io_min(mddev->queue, mddev->chunk_sectors << 9);
> +  /*blk_queue_io_opt(mddev->queue,
> +              (mddev->chunk_sectors << 9) * mddev->raid_disks);*/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXT7hGAAoJEDnsnt1WYoG55h8QAJzMQXICQNEZg2fM9nPZ5YSR
rJ2zUsJwvZuJgiZUXWVesm6PVmXtAiMMggL87jgTd/ZW8/EYL02DOn1ZkvMENxNE
ftzMKyaPj75a4n/Q2XfwqlL/AxqS7w7y0djXZVSWWWktSaj9qiJHtL8dBP6dkS+N
IWKfQ8lI9iYO1EgqUKxAVxBqb5xnm8PTAWRuSZ/yub0J0l5J6V8O7v1uMkKaBHX0
yM1mj920korM7/URWfNfhKDR/ksNvcVbarqnDXayA5Z8+eSiueoadWyQXgM/u8BX
5SP+UEcwxH3VARLEfrzYU1/yiCQ5J69reTSIUXTxz2sJ3mFLTSREOP16wVbmtTCp
9BsYE4WPjIG+oKJ160DmZlEqyV929S2N3c/pA0iT6+i4YzOv8JhPBPeqeG70Wlj3
/W1MJjXCAFiHnLcSKAbbBqbKmJg0diOTGmu0EsMvEjnjW9tj+Gg5OkhVhqUXY3cs
ogSb1+IMYGDsQS/OiXbAJ3r7MxH2VCj468YURf360gQbgruogOLkD7LBJbocmVrX
TFeXBlSypbNv4qzYtgyLziRtJtIDrk4OREK9c2CzpN/VsIC86DxR3y1nrvHhKl9m
vg1ehlGjvB/cZqqjylPlaFA9S50rXEQzsC2EteFyu3xNgYc56HoABjDV0CB6bCdi
wKVUz7j2zmKyuKjAUvnP
=Y5f0
-----END PGP SIGNATURE-----
--=-=-=--
