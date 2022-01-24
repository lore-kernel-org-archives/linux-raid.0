Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2CBBC433EF
	for <linux-raid@archiver.kernel.org>; Mon, 24 Jan 2022 16:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244031AbiAXQ6g (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 24 Jan 2022 11:58:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243849AbiAXQ6f (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 24 Jan 2022 11:58:35 -0500
X-Greylist: delayed 584 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 24 Jan 2022 08:58:35 PST
Received: from c.mx.filmlight.ltd.uk (c.mx.filmlight.ltd.uk [IPv6:2a05:d018:e66:3130::21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C592C06173B
        for <linux-raid@vger.kernel.org>; Mon, 24 Jan 2022 08:58:35 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by omni.filmlight.ltd.uk (Postfix) with ESMTP id 83AD440000C3;
        Mon, 24 Jan 2022 16:48:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 omni.filmlight.ltd.uk 83AD440000C3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=filmlight.ltd.uk;
        s=default; t=1643042930;
        bh=hs0yVgqC8MYDSRVAIhUfqhZxhu6zvHAwKmilqkesMVs=;
        h=Subject:From:In-Reply-To:Date:Cc:References:To:From;
        b=dX8ek/nFFE1k/ijsWZAGZb/gdaMmNAzAhpGehlv4plpdLiPLqzURQmT9g4EYUHsVf
         EBVeLAPV5QAIVfrrdAhTjY9j9lVijWe7ffOyaBUA1/vvv7mKWtk8RFhcEXQUgjJAuu
         y+38WxLJdUenhEDyTDAlHzRAdN8KjX5A0OLRExuA=
Received: from smtpclient.apple (cpc122860-stev8-2-0-cust234.9-2.cable.virginm.net [81.111.212.235])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: roger)
        by omni.filmlight.ltd.uk (Postfix) with ESMTPSA id 25A5D801F82;
        Mon, 24 Jan 2022 16:48:50 +0000 (GMT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.20.0.1.32\))
Subject: Re: [dm-devel] Raid0 performance regression
From:   Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <70008df6-ef90-6e8d-8a57-9b30077508e7@molgen.mpg.de>
Date:   Mon, 24 Jan 2022 16:48:49 +0000
Cc:     Roger Willcocks <roger@filmlight.ltd.uk>, dm-devel@redhat.com,
        Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        Lukas Straub <lukasstraub2@web.de>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C5CCA1CE-E120-4BCB-925E-981DBA7A29F4@filmlight.ltd.uk>
References: <747C2684-B570-473E-9146-E8AB53102236@filmlight.ltd.uk>
 <20220123180058.372f72ce@gecko.fritz.box>
 <70008df6-ef90-6e8d-8a57-9b30077508e7@molgen.mpg.de>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
X-Mailer: Apple Mail (2.3693.20.0.1.32)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> On 23 Jan 2022, at 21:34, Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>=20
> Dear Roger,
>=20
>=20
> Am 23.01.22 um 19:00 schrieb Lukas Straub:
>> CC'ing Song Liu (md-raid maintainer) and linux-raid mailing list.
>> On Fri, 21 Jan 2022 16:38:03 +0000 Roger Willcocks wrote:
>=20
>>> we noticed a thirty percent drop in performance on one of our raid
>>> arrays when switching from CentOS 6.5 to 8.4; it uses raid0-like
>=20
> For those outside the CentOS universe, what Linux kernel versions are =
those?
>=20

2.6.32 (and backported changes) and 4.18.0 (sim.)

>>> striping to balance (by time) access to a pair of hardware raid-6
>>> arrays. The underlying issue is also present in the native raid0
>>> driver so herewith the gory details; I'd appreciate your thoughts.
>>>=20
>>> --
>>>=20
>>> blkdev_direct_IO() calls submit_bio() which calls an outermost
>>> generic_make_request() (aka submit_bio_noacct()).
>>>=20
>>> md_make_request() calls blk_queue_split() which cuts an incoming
>>> request into two parts with the first no larger than =
get_max_io_size()
>>> bytes (which in the case of raid0, is the chunk size):
>>>=20
>>>   R -> AB
>>>   blk_queue_split() gives the second part 'B' to =
generic_make_request()
>>> to worry about later and returns the first part 'A'.
>>>=20
>>> md_make_request() then passes 'A' to a more specific request =
handler,
>>> In this case raid0_make_request().
>>>=20
>>> raid0_make_request() cuts its incoming request into two parts at the
>>> next chunk boundary:
>>>=20
>>> A -> ab
>>>=20
>>> it then fixes up the device (chooses a physical device) for 'a', and
>>> gives both parts, separately, to generic make request()
>>>=20
>>> This is where things go awry, because 'b' is still targetted to the
>>> original device (same as 'B'), but 'B' was queued before 'b'. So we
>>> end up with:
>>>=20
>>>   R -> Bab
>>>=20
>>> The outermost generic_make_request() then cuts 'B' at
>>> get_max_io_size(), and the process repeats. Ascii art follows:
>>>=20
>>>=20
>>>     /---------------------------------------------------/   incoming =
rq
>>>=20
>>>     /--------/--------/--------/--------/--------/------/   =
max_io_size
>>>       =
|--------|--------|--------|--------|--------|--------|--------| chunks
>>>=20
>>> |...=3D=3D=3D=3D=3D|---=3D=3D=3D=3D=3D|---=3D=3D=3D=3D=3D|---=3D=3D=3D=
=3D=3D|---=3D=3D=3D=3D=3D|---=3D=3D=3D=3D=3D|--......| rq out
>>>       a    b  c     d  e     f  g     h  i     j  k     l
>>>=20
>>> Actual submission order for two-disk raid0: 'aeilhd' and 'cgkjfb'
>>>=20
>>> --
>>>=20
>>> There are several potential fixes -
>>>=20
>>> simplest is to set raid0 blk_queue_max_hw_sectors() to UINT_MAX
>>> instead of chunk_size, so that raid0_make_request() receives the
>>> entire transfer length and cuts it up at chunk boundaries;
>>>=20
>>> neatest is for raid0_make_request() to recognise that 'b' doesn't
>>> cross a chunk boundary so it can be sent directly to the physical
>>> device;
>>>=20
>>> and correct is for blk_queue_split to requeue 'A' before 'B'.
>>>=20
>>> --
>>>=20
>>> There's also a second issue - with large raid0 chunk size (256K), =
the
>>> segments submitted to the physical device are at least 128K and
>>> trigger the early unplug code in blk_mq_make_request(), so the
>>> requests are never merged. There are legitimate reasons for a large
>>> chunk size so this seems unhelpful.
>>>=20
>>> --
>>>=20
>>> As I said, I'd appreciate your thoughts.
>=20
> Thank you for the report and the analysis.
>=20
> Is the second issue also a regression? If not, I suggest to split it =
into a separate thread.
>=20

Yes this is also a regression, both issues above have to be addressed to =
recover the
original performance.

Specifically, an md raid0 array with 256K chunk size interleaving two x =
12-disk raid6
devices (Adaptec 3154 controller, 50MB files stored contiguously on =
disk, four threads)
can achieve a sequential read rate of 3800 MB/sec with the (very) old =
6.5 kernel; this
falls to 2500 MB/sec with the relatively newer kernel.

This change to raid0.c:

-               blk_queue_max_hw_sectors(mddev->queue, =
mddev->chunk_sectors);
+              blk_queue_max_hw_sectors(mddev->queue, UINT_MAX);

improves things somewhat, the sub-chunk requests are now submitted in =
order but we
still only get 2800 MB/sec because no merging takes place; the =
controller struggles to
keep up with the large number of sub-chunk transfers. This additional =
change to=20
blk-mq.c:

-		if (request_count >=3D BLK_MAX_REQUEST_COUNT || (last &&
+		if (request_count >=3D BLK_MAX_REQUEST_COUNT || (false =
&& last &&
 		    blk_rq_bytes(last) >=3D BLK_PLUG_FLUSH_SIZE)) {
 			blk_flush_plug_list(plug, false);

Brings performance back to 6.5 levels.


>=20
> Kind regards,
>=20
> Paul
>=20

