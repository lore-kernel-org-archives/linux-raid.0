From: Wilhelm Meier <wilhelm.meier@fh-kl.de>
Subject: Re: mdadm --incremental /dev/md?? instead of /dev/md/d??
Date: Mon, 1 Dec 2008 07:57:31 +0100
Message-ID: <200812010757.31539.wilhelm.meier@fh-kl.de>
References: <200811301543.47003.wilhelm.meier@fh-kl.de> <5733f4fe1f2b309195c0c2a328942eff.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5733f4fe1f2b309195c0c2a328942eff.squirrel@neil.brown.name>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am Montag 01 Dezember 2008 schrieb NeilBrown:
> On Mon, December 1, 2008 1:43 am, Wilhelm Meier wrote:
> > How can I switch the naming scheme for the mdadm incremental-mode
> > using /dev/md42 instead of /dev/md/d42 for adding a device or
> > constructing an array with a minor-number 42?
>
> I thought it did default to /dev/md42
> Do you have something like
>   CREATE auto=mdp
> in /etc/mdadm.conf?? 

no. auto=yes

> Making that "auto=md" might fix it. 

have to check this later

>
> > mdadm --version: 2.6.2
>
> That is about 18 months old now.  An upgrade might be a good idea.

Oh yes. But this is already the debian-etch-backports version. The 
debian-etch version is 2.5.8 (missing --incremental)

>
> NeilBrown
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-raid" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Wilhelm
