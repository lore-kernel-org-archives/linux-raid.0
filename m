From: Tru Huynh <tru@pasteur.fr>
Subject: Re: question on how to (correctly) build an initrd for a root disk
	on a RAID1
Date: Wed, 29 Oct 2008 13:13:27 +0100
Message-ID: <20081029121327.GP30263@sillage.bis.pasteur.fr>
References: <9f5edc120810261937w339f2919p4f7ce82fbcaf2149@mail.gmail.com> <20081027071613.GA8197@maude.comedia.it> <9f5edc120810270534j3d969d2s18c1017755990c30@mail.gmail.com> <20081028064354.GD7764@percy.comedia.it> <9f5edc120810280520i3ff4855fne765069beeca27e9@mail.gmail.com> <9f5edc120810281842q7421ea92of6c466693f8f5b7f@mail.gmail.com> <9f5edc120810281903y67c0b56eia869d76cfa048ce3@mail.gmail.com> <9f5edc120810281949w477fb376l6ca1b6e96bb6f791@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9f5edc120810281949w477fb376l6ca1b6e96bb6f791@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Oct 28, 2008 at 10:49:27PM -0400, Joe Landman wrote:
...
> Replacing this mkinitrd with 6.0.19-4 (by doing lots of rpmbuild 's
> against FC8/9 packages and installing), we did in fact see the
> mdadm.conf get explicitly added in during the mkinitrd.
> 
> /sbin/mdadm -> /tmp/initrd.Jz3686/sbin/mdadm
> /etc/mdadm.conf -> /tmp/initrd.Jz3686/etc/mdadm.conf
> 
> Upon reboot, it works.
> 
...
> 
> While this works, this is not a solution I want to hand to our
> users/customers.  Could someone toss me a pointer as to who owns
> mkinitrd at RHEL/Centos so I can report this?  Basically this is not a
> linux-raid bug, but a bug in the mkinitrd assumptions (or possibly
> something that needs to be built into the kernel which is not
> explicitly indicated in mkinitrd).
http://bugzilla.redhat.com would be the first step since CentOS
is rebuilding from upstream (bugs included), although 
it could provided it's own features in the extras
repository.
http://bugs.centos.org could also be used for RFE in CentOS extras
http://wiki.centos.org/AdditionalResources/Repositories has a list
of "recommended" repositories.
One caveat, I am not sure that this bug will ever be fixed
since rebuilding a custom kernel is not really supported 
on both distributions.

Cheers,

Tru
-- 
Dr Tru Huynh          | http://www.pasteur.fr/recherche/unites/Binfs/
mailto:tru@pasteur.fr | tel/fax +33 1 45 68 87 37/19
Institut Pasteur, 25-28 rue du Docteur Roux, 75724 Paris CEDEX 15 France  
