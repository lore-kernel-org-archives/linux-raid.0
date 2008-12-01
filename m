From: Wilhelm Meier <wilhelm.meier@fh-kl.de>
Subject: Re: mdadm --incremental and different config file
Date: Mon, 1 Dec 2008 08:02:23 +0100
Message-ID: <200812010802.23907.wilhelm.meier@fh-kl.de>
References: <200811301551.08646.wilhelm.meier@fh-kl.de> <4844862be26c89d648e57bf90aae498d.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4844862be26c89d648e57bf90aae498d.squirrel@neil.brown.name>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am Montag 01 Dezember 2008 schrieb NeilBrown:
> On Mon, December 1, 2008 1:51 am, Wilhelm Meier wrote:
> > Hi,
> >
> > how can I use a different config file for the incremental mode:
> > -c is not working in this mode?
>
> Unfortunately you cannot without modifying the code.
> If you
>
>   git clone git://neil.brown.name/mdadm
>   cd mdadm
>   make install
>
> then you will be able to do this.
>
> (i.e. I have just committed a fix).

ok, thanks. I will try this later on

>
> NeilBrown
>
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-raid" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Wilhelm
