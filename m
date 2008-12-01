From: "NeilBrown" <neilb@suse.de>
Subject: Re: mdadm --incremental /dev/md?? instead of /dev/md/d??
Date: Mon, 1 Dec 2008 11:26:56 +1100 (EST)
Message-ID: <5733f4fe1f2b309195c0c2a328942eff.squirrel@neil.brown.name>
References: <200811301543.47003.wilhelm.meier@fh-kl.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200811301543.47003.wilhelm.meier@fh-kl.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wilhelm Meier <wilhelm.meier@fh-kl.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, December 1, 2008 1:43 am, Wilhelm Meier wrote:
> How can I switch the naming scheme for the mdadm incremental-mode
> using /dev/md42 instead of /dev/md/d42 for adding a device or
> constructing an array with a minor-number 42?

I thought it did default to /dev/md42
Do you have something like
  CREATE auto=mdp
in /etc/mdadm.conf??  Making that "auto=md" might fix it.

>
> mdadm --version: 2.6.2

That is about 18 months old now.  An upgrade might be a good idea.

NeilBrown


