From: "Zeno R.R. Davatz" <zdavatz@ywesee.com>
Subject: Re: mbr-install for Raid 1, rerun Lilo necessary?
Date: Wed, 6 Oct 2004 10:56:20 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20041006105620.465baff7@zrr.local>
References: <20041005093440.2b639e71@zrr.local>
	<41626483.60505@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41626483.60505@tls.msk.ru>
To: RAID Linux <linux-raid@vger.kernel.org>
Cc: Michael Tokarev <mjt@tls.msk.ru>
List-Id: linux-raid.ids

On Tue, 05 Oct 2004 13:08:19 +0400
Michael Tokarev <mjt@tls.msk.ru> wrote:

> No, you would have to use boot=/dev/md0 in your lilo.conf,
Do I have to run 'lilo -v' so lilo gets this?

Because whenever I run lilo -v (22.5.8) with 'boot=/dev/md0 I get the wonderful Error of:
Fatal: Trying to map files from unnamed device 0x0000 (NFS ?)

Any hints?

Thanks
Zeno
