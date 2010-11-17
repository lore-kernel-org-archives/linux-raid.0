From: Mike Viau <viaum@sheridanc.on.ca>
Subject: RE: How to recreate a dmraid RAID array with mdadm (was: no subject)
Date: Tue, 16 Nov 2010 20:02:17 -0500
Message-ID: <BAY148-w211AE8BF243615980CE527EF380@phx.gbl>
References: <BAY148-w337E193E7493BB69F27B31EF350@phx.gbl>,<20101115162122.4fef2542@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101115162122.4fef2542@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, debian-user@lists.debian.org
List-Id: linux-raid.ids


> On Mon, 15 Nov 2010 16:21:22 +1100 <neilb@suse.de> wrote:
> > On Sun, 14 Nov 2010 01:50:42 -0500 Mike wrote:
> > 
> > How does one fix the problem of not having the array not starting at boot?
> >
>
> To be able to answer that one would need to know exactly what is in the
> initramfs. And unfortunately all distros are different and I'm not
> particularly familiar with Ubuntu.
>
> Maybe if you
> mkdir /tmp/initrd
> cd /tmp/initrd
> zcat /boot/initrd.img-2.6.32-5-amd64 | cpio -idv
>
> and then have a look around and particularly report etc/mdadm/mdadm.conf
> and anything else that might be interesting.
>
> If the mdadm.conf in the initrd is the same as in /etc/mdadm, then it
> *should* work.
>

Thanks again Neil. I got a chance to examine my systems initramfs to discover two differences in the local copy of mdadm.conf and the initramfs's copy.

The initramfs's copy contains:

DEVICE partitions
HOMEHOST <system>
ARRAY metadata=imsm UUID=084b969a:0808f5b8:6c784fb7:62659383
ARRAY /dev/md/OneTB-RAID1-PV container=084b969a:0808f5b8:6c784fb7:62659383 member=0 UUID=ae4a1598:72267ed7:3b34867b:9c56497a

So both ARRAY lines got copied over to the initramfs's copy of mdadm.conf, but

CREATE owner=root group=disk mode=0660 auto=yes

and

MAILADDR root

were not carried over on the update-initramfs command.


To your clearly better understanding of all this, does the CREATE stanza NEED to be present in the initramfs's copy of mdadm.conf in order for the array to be created on boot? If so, how can one accomplish this, so that the line is added whenever a new initramfs is created for the kernel?


My diff findings between the local copy of mdadm.conf and the initramfs's copy pasted at:
http://debian.pastebin.com/5VNnd9g1


Thanks for your help.


-M
 		 	   		  