From: Nagilum <nagilum@nagilum.org>
Subject: Re: [PATCH] md:Add blk_plug in sync_thread.
Date: Mon, 11 Jun 2012 11:32:41 +0200
Message-ID: <4FD5BB39.4040406@nagilum.org>
References: <201206111716521256611@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201206111716521256611@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/11/2012 11:16 AM, majianpeng wrote:
> Add blk_plug in sync_thread will increase the performance of sync.
> Because sync_thread did not blk_plug,so when raid sync, the bio merge
> not well.
>
> Testing environment:
> SATA controller: Intel Corporation 82801JI (ICH10 Family) SATA AHCI
> Controller.
> OS:Linux xxx 3.5.0-rc2+ #340 SMP Tue Jun 12 09:00:25 CST 2012
> x86_64 x86_64 x86_64 GNU/Linux.
> RAID5: four ST31000524NS disk.
>
> Without blk_plug:recovery speed about 63M/Sec;
> Add blk_plug:recovery speed about 120M/Sec.
Whahoo!! :)

