From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: md multipath and failover
Date: Thu, 18 Sep 2003 11:12:54 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030918091254.GB30149@marowsky-bree.de>
References: <sf607904.085@gw.state.sc.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <sf607904.085@gw.state.sc.us>
To: Doug Griswold <griswld@cio.sc.gov>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2003-09-11T13:30:41,
   Doug Griswold <griswld@cio.sc.gov> said:

> deal.  My next question is how can I apply this patch to the red hat
> supplied kernel 2.4.9-27 enterprise so I will still have red hat supp=
ort
> on this kernel?

No idea. I doubt RH will support a patched kernel anyway, even if you
started from their base source. I suggest you contact your support
representative about this.

> Also is there away with this patch applied to get failback? =20

You have to do it in user-space, ie monitor the paths periodically and
restore them if you are satisfied.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering		ever tried. ever failed. no matter.
SuSE Labs				try again. fail again. fail better.
Research & Development, SuSE Linux AG		-- Samuel Beckett

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
