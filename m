From: Andrew Morton <akpm@osdl.org>
Subject: Re: sata badness in 2.6.20-rc1? [Was: Re: md patches in -mm]
Date: Tue, 19 Dec 2006 16:08:40 -0800
Message-ID: <20061219160840.bb6b155f.akpm@osdl.org>
References: <20061217160056.GA3555@amd64.of.nowhere>
	<362582.18476.qm@web31811.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <362582.18476.qm@web31811.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: ltuikov@yahoo.com
Cc: Jurriaan <thunder7@xs4all.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Garzik <jeff@garzik.org>, Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Tejun Heo <htejun@gmail.com>, Alan <alan@lxorguk.ukuu.org.uk>
List-Id: linux-raid.ids

On Tue, 19 Dec 2006 15:26:00 -0800 (PST)
Luben Tuikov <ltuikov@yahoo.com> wrote:

> The reason was that my dev tree was tainted by this bug:
> 
>         if (good_bytes &&
> -           scsi_end_request(cmd, 1, good_bytes, !!result) == NULL)
> +           scsi_end_request(cmd, 1, good_bytes, result == 0) == NULL)
>                 return;
> 
> in scsi_io_completion().  I had there !!result which is wrong, and when
> I diffed against master, it produced a bad patch.

Oh.  I thought that got sorted out.  It's a shame this wasn't made clear to
me..

> As James mentioned one of the chunks is good and can go in.

Please send a new patch, not referential to any previous patch or email,
including full changelogging.

