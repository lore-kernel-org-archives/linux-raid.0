From: Bill Nottingham <notting@redhat.com>
Subject: Re: [[Patch mdadm] 2/5] Move the files mdmon opens into /dev/ to
 support handoff after pivotroot
Date: Mon, 8 Feb 2010 11:56:08 -0500
Message-ID: <20100208165608.GA19344@nostromo.devel.redhat.com>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com>
 <1263242294-5353-3-git-send-email-dledford@redhat.com>
 <20100119110930.107ca42e@notabene>
 <4B55F138.7060008@redhat.com>
 <20100204174009.6072ec07@notabene.brown>
 <4B6B15B3.8030205@redhat.com>
 <20100208144522.62b1e568@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100208144522.62b1e568@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Doug Ledford <dledford@redhat.com>, linux-raid@vger.kernel.org, initramfs@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, martin f krafft <madduck@debian.org>, Michal Marek <mmarek@suse.de>, Hans de Goede <hdegoede@redhat.com>
List-Id: linux-raid.ids

Neil Brown (neilb@suse.de) said: 
> Yes, I have not been thinking much about the shutdown side of the equation.
> Cleanup isn't an issue - you do not need to clean up /var/run when shutting
> down because it always happens on boot (and won't happen on a crash anyway).
> The only possible issue that I can see is if you want to unmount /var before
> setting / to read-only.  You won't be able to do this because mdmon holds an
> open file descriptor on /var.
> So instead of unmounting /var you would need to remount it read-only, and
> then remount '/' read-only.
> 
> Is that going to be a problem?

It's certainly a change in behavior. Historically all non-root filesystems
can be cleanly unmounted, then root is marked read-only, then you
halt/reboot.

> The first is as a cache for the mapping from UUID to md device (major/minor
> number).  This is particularly need for Incremental mode so that when a new
> device is found, it is easy to find if an md device already is (partially)
> assembled for that array.
> Being a cache, this information can be recreated at any time - simply read
> the meta from some device in each array in record the UUID.  This can be
> done with
>    mdadm --incremental --rebuild-map
> (or mdadm -Ir).
> I think "mdadm --incremental" might even do this transparently if the mapfile
> cannot be found.

This seems like it could be integrated with the udev database, could it not?
(Whether or not you want this dependency is another matter.)

>  3/ Document that at mdmon may prevent /var from being unmounted and
>     recommend "-o remount,ro" as an alternative.

As said above, I think this is a problem.

Bill
