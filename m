From: Roman Mamedov <rm@romanrm.net>
Subject: Re: strange mirror write perf
Date: Mon, 20 Mar 2017 10:07:42 +0500
Message-ID: <20170320100742.712ebe4d@natsu>
References: <eda41097b3c3a385f83041f0df372912@grim-is-a-geek.fr>
        <6ec5f2dbefa2b7489d9f39d4833d5113@grim-is-a-geek.fr>
        <c0981a7c8b13facace1228ed0f99efdc@grim-is-a-geek.fr>
        <3a5e061d-696d-f331-87a5-411edc514ada@websitemanagers.com.au>
        <91d1857a35f0c659387a409cc147ac92@grim-is-a-geek.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <91d1857a35f0c659387a409cc147ac92@grim-is-a-geek.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Youenn Gestin <youenn.gestin@grim-is-a-geek.fr>
Cc: Adam Goryachev <mailinglists@websitemanagers.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 20 Mar 2017 01:44:09 +0100
Youenn Gestin <youenn.gestin@grim-is-a-geek.fr> wrote:

> abyss ~ # dd bs=1M count=2024 if=/dev/zero of=/dev/md/md6to 
> conv=fdatasync
> 2024+0 records in
> 2024+0 records out
> 2122317824 bytes (2,1 GB, 2,0 GiB) copied, 14,5074 s, 146 MB/s
> 
> I'll check about this function to see if i'll need it or not tomorow,

Instead of disabling it you can alter the bitmap chunk size, and at larger
chunk sizes it does not affect the performance as much.
http://tgharold.blogspot.fr/2013/01/mdadm-using-bitmaps-to-speed-up-rebuilds.html
For 6TB drives try 256 or even 512MB for the size.

-- 
With respect,
Roman
