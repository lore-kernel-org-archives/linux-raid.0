From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Mon, 20 Apr 2009 22:04:47 +0200
Message-ID: <20090420200447.GA4907@lazy.lzy>
References: <20090420181736.GB4236@lazy.lzy> <20090420194956144.ESZJ23317@cdptpa-omta01.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090420194956144.ESZJ23317@cdptpa-omta01.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 20, 2009 at 02:49:48PM -0500, Leslie Rhorer wrote:
> Um, this is slightly odd, but when I use --examine --scan on my array, it
> returns nothing.  If I run it on an element of the array I get:
> 
> ARRAY /dev/md0 level=raid6 num-devices=10
> UUID=5a53eeb8:4d87963b:4cb502e9:37bde716
> 
> 'Nothing about the metadata or the array name.

That's interesting, maybe Neil should comment on this.
 
> > Of course, /dev/mdadm.conf has the same entry.
> 
> Um, did you mean /etc/mdadm/mdadm.conf?  I don't have a /dev/mdadm.conf on
> my system.

Yeah, I meant /etc/mdadm.conf...

bye,

-- 

piergiorgio
