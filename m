From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm --incremental /dev/md?? instead of /dev/md/d??
Date: Tue, 2 Dec 2008 16:22:10 +1100
Message-ID: <18740.50690.3253.790188@notabene.brown>
References: <200811301543.47003.wilhelm.meier@fh-kl.de>
	<5733f4fe1f2b309195c0c2a328942eff.squirrel@neil.brown.name>
	<200812010757.31539.wilhelm.meier@fh-kl.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Wilhelm Meier on Monday December 1
Sender: linux-raid-owner@vger.kernel.org
To: Wilhelm Meier <wilhelm.meier@fh-kl.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday December 1, wilhelm.meier@fh-kl.de wrote:
> Am Montag 01 Dezember 2008 schrieb NeilBrown:
> > On Mon, December 1, 2008 1:43 am, Wilhelm Meier wrote:
> > > How can I switch the naming scheme for the mdadm incremental-mode
> > > using /dev/md42 instead of /dev/md/d42 for adding a device or
> > > constructing an array with a minor-number 42?
> >
> > I thought it did default to /dev/md42
> > Do you have something like
> >   CREATE auto=mdp
> > in /etc/mdadm.conf?? 
> 
> no. auto=yes

Hmm.
Can you show me "mdadm --examine" on one of the drives that you are
adding with --incremental ??

NeilBrown
