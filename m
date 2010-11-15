From: Neil Brown <neilb@suse.de>
Subject: Re: How to recreate a dmraid RAID array with mdadm (was: no
 subject)
Date: Mon, 15 Nov 2010 16:21:22 +1100
Message-ID: <20101115162122.4fef2542@notabene.brown>
References: <BAY148-w337E193E7493BB69F27B31EF350@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BAY148-w337E193E7493BB69F27B31EF350@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Viau <viaum@sheridanc.on.ca>
Cc: linux-raid@vger.kernel.org, debian-user@lists.debian.org
List-Id: linux-raid.ids

On Sun, 14 Nov 2010 01:50:42 -0500
Mike Viau <viaum@sheridanc.on.ca> wrote:

> Again, How does one fix the problem of not having the array not starting at boot?
> 

To be able to answer that one would need to know exactly what is in the
initramfs.  And unfortunately all distros are different and I'm not
particularly familiar with Ubuntu.

Maybe if you 
  mkdir /tmp/initrd
  cd /tmp/initrd
  zcat /boot/initrd.img-2.6.32-5-amd64 | cpio -idv

 and then have a look around and particularly report etc/mdadm/mdadm.conf
 and anything else that might be interesting.

If the mdadm.conf in the initrd is the same as in /etc/mdadm, then it
*should* work.


NeilBrown
