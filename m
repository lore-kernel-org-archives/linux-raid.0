From: Neil Brown <neilb@suse.de>
Subject: Re:
Date: Mon, 8 Mar 2010 12:53:22 +1100
Message-ID: <20100308125322.6d64a573@notabene.brown>
References: <8F.1B.22814.EC4549B4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8F.1B.22814.EC4549B4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 7 Mar 2010 19:37:15 -0600
"Leslie Rhorer" <lrhorer@satx.rr.com> wrote:

> I am running mdadm 2.6.7.2-1, and 2.6.7.2-3 is available under my distro.
> Do either of these versions support reshaping an array from RAID5 to RAID6?

No

> Does any later version?

Yes.


You need mdadm-3.1.1 plus linux 2.6.32.

NeilBrown

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

