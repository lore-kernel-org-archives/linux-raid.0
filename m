From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] RAID-6 check standalone
Date: Tue, 22 Mar 2011 09:59:05 +1100
Message-ID: <20110322095905.737fb1d5@notabene.brown>
References: <20110221204551.GA15675@lazy.lzy>
	<20110321140244.2314b4b4@notabene.brown>
	<20110321104007.GA15379@lazy.lzy>
	<20110321220457.29d52f5c@notabene.brown>
	<20110321115440.GA15635@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110321115440.GA15635@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 21 Mar 2011 12:54:41 +0100 Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:

> Hi Neil,
> 
> On Mon, Mar 21, 2011 at 10:04:57PM +1100, NeilBrown wrote:
> > On Mon, 21 Mar 2011 11:40:07 +0100 Piergiorgio Sartor
> > <piergiorgio.sartor@nexgo.de> wrote:
> > 
> > 
> > > > I have applied this patch to me git now - with some minor changes.
> > > 
> > > Thanks.
> > > 
> > > One question, I did not find the previous patch to "restripe.c",
> > > which was adding the ":offset" capability. This was in order to
> > > be able to cope with metadata 1.1 or 1.2 (offset to be determined).
> > 
> > I cannot seem to find it.  Please resend.
> 
> neither me, maybe I just forgot to send it.
> 
> Anyway, here below is the patch:
> 
> --- cut here ---
> 
> diff -urN a/restripe.c b/restripe.c
> --- a/restripe.c	2011-02-18 23:18:20.377740868 +0100
> +++ b/restripe.c	2011-02-18 23:30:07.589841525 +0100
> @@ -875,6 +875,14 @@
>  		exit(3);
>  	}
>  	for (i=0; i<raid_disks; i++) {
> +		char *p;
> +		p = strchr(argv[9+i], ':');
> +
> +		if(p != NULL) {
> +			*p++ = '\0';
> +			offsets[i] = atoll(p) * 512;
> +		}
> +			
>  		fds[i] = open(argv[9+i], O_RDWR);
>  		if (fds[i] < 0) {
>  			perror(argv[9+i]);
> 

OK, that's applied now.
thanks,
NeilBrown

