From: Neil Brown <neilb@suse.de>
Subject: Re: Confused about reshape?
Date: Mon, 31 May 2010 15:57:53 +1000
Message-ID: <20100531155753.6662b882@notabene.brown>
References: <20100531145027.73d85ffe@notabene.brown>
	<A6.8D.28437.6D9430C4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A6.8D.28437.6D9430C4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 31 May 2010 00:32:07 -0500
"Leslie Rhorer" <lrhorer@satx.rr.com> wrote:

> > Just tell mdadm what you want and it will do it, or report that it cannot.
> 
> 	Um, OK, I tried it, and it failed:
> 
> Backup:/# mdadm --grow /dev/md0 --level=6
> mdadm: no changes to --grow

cat /proc/mdstat ??
mdadm -D /dev/md0 ??
mdadm -V ??
uname -a ??

Maybe add -vv to the --grow

NeilBrown
