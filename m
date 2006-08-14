From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: Getting 'sync' to flush disk cache?
Date: Mon, 14 Aug 2006 21:34:58 +0200
Message-ID: <1155584098.2886.271.camel@laptopd505.fenrus.org>
References: <44E0C373.6060008@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <44E0C373.6060008@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Jens Axboe <axboe@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 2006-08-14 at 14:39 -0400, Jeff Garzik wrote:
> So...  has anybody given any thought to enabling fsync(2), fdatasync(2), 
> and sync_file_range(2) issuing a [FLUSH|SYNCHRONIZE] CACHE command?
> 
> This has bugged me for _years_, that Linux does not do this.  Looking at 
> forums on the web, it bugs a lot of other people too.

eh afaik 2.6.17 and such do this if you have barriers enabled...

