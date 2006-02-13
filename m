From: Chris Osicki <osk@admin.swisscom-mobile.ch>
Subject: Re: Question: array locking, possible?
Date: Mon, 13 Feb 2006 18:52:47 +0100
Message-ID: <20060213185247.2bb2ffee@mwdsp001.swissptt.ch>
References: <1C4766A743ADF74FAEDF2AAD0679BAA20767917E@cacexc03.americas.cpqcorp.net>
	<20060209204847.GA1387@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060209204847.GA1387@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Luca

On Thu, 9 Feb 2006 21:48:48 +0100
Luca Berra <luca.berra@comedia.it> wrote:

> On Thu, Feb 09, 2006 at 10:28:58AM -0800, Stern, Rick (Serviceguard Linux) wrote:
> >There is more interest, just not vocal.
> >
> >May want to look at LVM2 and its ability to use tagging to control enablement of VGs. This way it is not HW dependent.
> >
> I believe there is space in md1 superblock for a "cluster/exclusive"
> flag, if not the name field could be used

Great if there is space for it there is a hope.
Unfortunately I don't think my programming skills are up to
such a task as making proof-of-concept patches.

> what is missing is an interface between mdadm and cmcld so mdadm can ask
> cmcld permission to activate an array with the "cluster/exclusive" flag
> set.

For the time being we could live without it. I'm convinced HP would
make use of it once it's there.

And I wouldn't say mdadm should get permission from cmcld (for those
who don't know Service Guard cluster software from HP: cmcld is
the Cluster daemon). IMHO cmcld should clear the flag on the array
when initiating a fail-over in case the host which used it crashed.

Once again, what I would like it for is for preventing two hosts writing
the array at the same time because I accidentally activated it.
Without cmcld's awareness of the "cluster/exclusive" flag I would
always run mdadm with the '--force' option to enable the array during
package startup, because if I trust the cluster software I know the
fail-over is happening because the other node crashed or it is a
manual (clean) fail-over. 

We can discuss details of SG integration after Neil implemented this
flag. I can hope, you already found space for it ... ;-)

Regards,
Chris


> 
> L.
> 
> -- 
> Luca Berra -- bluca@comedia.it
>         Communication Media & Services S.r.l.
>  /"\
>  \ /     ASCII RIBBON CAMPAIGN
>   X        AGAINST HTML MAIL
>  / \
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
