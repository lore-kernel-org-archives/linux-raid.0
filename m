Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B7B7C4321E
	for <linux-raid@archiver.kernel.org>; Wed, 13 Oct 2021 06:29:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04F7360E97
	for <linux-raid@archiver.kernel.org>; Wed, 13 Oct 2021 06:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237893AbhJMGbp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 13 Oct 2021 02:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237918AbhJMGbn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 13 Oct 2021 02:31:43 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0822CC061762
        for <linux-raid@vger.kernel.org>; Tue, 12 Oct 2021 23:29:41 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id t11so1096959plq.11
        for <linux-raid@vger.kernel.org>; Tue, 12 Oct 2021 23:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=W+Po2ncML0dagir1ZXD2ovXOKvk/W+c/3o5vm+NA9cQ=;
        b=QomLyJ/uwXmEgOIdGiIKpgwe7fIN3sqRRqysUR703Xs3YgTlXaMfe2P+HII9dJHv27
         pe85K+wWKdH0PewpBtncrX+pK9/vv2ewnDdpNrXhC91Xk/Ncvs9CyiBnb8qEmm15S3FV
         6BEJ5rXVDozZ1lv8jDs3uSJtiPb9Dk/ZAAcM0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W+Po2ncML0dagir1ZXD2ovXOKvk/W+c/3o5vm+NA9cQ=;
        b=jdX+1fNhpO2we7vWlwcoR+Ul2/3iISngmR+SeD64QjJU6M4lSeI21REskiIenYvuxo
         FESQV0baySInkIiQgOpyRN5IfMlDMqRiSA2NkLAHnsLWG7RxxpPk1IhwdBRMNb+zpCc3
         7CKoZzidgsfs7fB6vTPRPU3XiWk0VWPVpi98FtfYT9m1mwF/mJyjFDgEvvok+wWapym0
         zefqQsUEpfcdfOI5KJXXUkTQlJAWArnK81FIeoonULlUBatX2A7kPluqqtkxYVi8r/c3
         H+/h6Bi+y4TBgaHTVZuxAb/VMie6he6qGcwTZyJrHpYpdmivYsgYhqrX8VtQjygfZvaa
         whxw==
X-Gm-Message-State: AOAM531R4gBG3EFlX4rPU8h3WjXTjxw171QMX7xLk/OR/Wbb8+9PiSg6
        4GhLpf5nM/cDCcI2tz2kfwsI9A==
X-Google-Smtp-Source: ABdhPJwwvDzOMlBdl8uBpL682Y/M/U5HFlms6OXsU9pvWhVrOJHosSbnvoIECvMOshQ6rTYdsLz56g==
X-Received: by 2002:a17:90b:4b4c:: with SMTP id mi12mr11492173pjb.57.1634106580411;
        Tue, 12 Oct 2021 23:29:40 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id x7sm12999948pfj.28.2021.10.12.23.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 23:29:39 -0700 (PDT)
Date:   Tue, 12 Oct 2021 23:29:39 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>,
        Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
        David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Theodore Ts'o <tytso@mit.edu>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Dave Kleikamp <shaggy@kernel.org>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Anton Altaparmakov <anton@tuxera.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        Jan Kara <jack@suse.com>, linux-block@vger.kernel.org,
        dm-devel@redhat.com, drbd-dev@lists.linbit.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
        linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org,
        linux-ntfs-dev@lists.sourceforge.net, ntfs3@lists.linux.dev,
        reiserfs-devel@vger.kernel.org
Subject: Re: [PATCH 25/29] ext4: use sb_bdev_nr_blocks
Message-ID: <202110122328.92B4FC41F4@keescook>
References: <20211013051042.1065752-1-hch@lst.de>
 <20211013051042.1065752-26-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013051042.1065752-26-hch@lst.de>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Oct 13, 2021 at 07:10:38AM +0200, Christoph Hellwig wrote:
> Use the sb_bdev_nr_blocks helper instead of open coding it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/ext4/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 0775950ee84e3..3dde8be5df490 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4468,7 +4468,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
>  		goto cantfind_ext4;
>  
>  	/* check blocks count against device size */
> -	blocks_count = sb->s_bdev->bd_inode->i_size >> sb->s_blocksize_bits;
> +	blocks_count = sb_bdev_nr_blocks(sb);

Is s_blocksize_bits always 9 here? If not, this isn't equivalent.

-Kees

>  	if (blocks_count && ext4_blocks_count(es) > blocks_count) {
>  		ext4_msg(sb, KERN_WARNING, "bad geometry: block count %llu "
>  		       "exceeds size of device (%llu blocks)",
> -- 
> 2.30.2
> 

-- 
Kees Cook
