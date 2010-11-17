From: Neil Brown <neilb@suse.de>
Subject: Re: How to recreate a dmraid RAID array with mdadm (was: no
 subject)
Date: Wed, 17 Nov 2010 12:26:47 +1100
Message-ID: <20101117122647.48c7b67a@notabene.brown>
References: <BAY148-w337E193E7493BB69F27B31EF350@phx.gbl>
	<20101115162122.4fef2542@notabene.brown>
	<BAY148-w211AE8BF243615980CE527EF380@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BAY148-w211AE8BF243615980CE527EF380@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Viau <viaum@sheridanc.on.ca>
Cc: linux-raid@vger.kernel.org, debian-user@lists.debian.org
List-Id: linux-raid.ids

On Tue, 16 Nov 2010 20:02:17 -0500
Mike Viau <viaum@sheridanc.on.ca> wrote:

> 
> > On Mon, 15 Nov 2010 16:21:22 +1100 <neilb@suse.de> wrote:
> > > On Sun, 14 Nov 2010 01:50:42 -0500 Mike wrote:
> > > 
> > > How does one fix the problem of not having the array not starting at boot?
> > >
> >
> > To be able to answer that one would need to know exactly what is in the
> > initramfs. And unfortunately all distros are different and I'm not
> > particularly familiar with Ubuntu.
> >
> > Maybe if you
> > mkdir /tmp/initrd
> > cd /tmp/initrd
> > zcat /boot/initrd.img-2.6.32-5-amd64 | cpio -idv
> >
> > and then have a look around and particularly report etc/mdadm/mdadm.conf
> > and anything else that might be interesting.
> >
> > If the mdadm.conf in the initrd is the same as in /etc/mdadm, then it
> > *should* work.
> >
> 
> Thanks again Neil. I got a chance to examine my systems initramfs to discover two differences in the local copy of mdadm.conf and the initramfs's copy.
> 
> The initramfs's copy contains:
> 
> DEVICE partitions
> HOMEHOST <system>
> ARRAY metadata=imsm UUID=084b969a:0808f5b8:6c784fb7:62659383
> ARRAY /dev/md/OneTB-RAID1-PV container=084b969a:0808f5b8:6c784fb7:62659383 member=0 UUID=ae4a1598:72267ed7:3b34867b:9c56497a
> 
> So both ARRAY lines got copied over to the initramfs's copy of mdadm.conf, but
> 
> CREATE owner=root group=disk mode=0660 auto=yes
> 
> and
> 
> MAILADDR root
> 
> were not carried over on the update-initramfs command.
> 
> 
> To your clearly better understanding of all this, does the CREATE stanza NEED to be present in the initramfs's copy of mdadm.conf in order for the array to be created on boot? If so, how can one accomplish this, so that the line is added whenever a new initramfs is created for the kernel?

No, those differences couldn't explain it not working.

I would really expect that mdadm.conf file to successfully assemble the
RAID1.

As you have the same in /etc/mdadm/mdadm.conf you could see what is happening
by:

 mdadm -Ss

to stop all md arrays, then

 mdadm -Asvv

to auto-start everything in mdadm.conf and be verbose about that is happening.

If that fails to start the raid1, then the messages it produces will be
helpful in understanding why.
If it succeeds, then there must be something wrong with the initrd...
Maybe '/sbin/mdmon' is missing...  Or maybe it doesn't run
  mdadm -As
(or equivalently:  mdadm --assemble --scan)
but doesn't something else.  To determine what you would need to search for
'mdadm' in all the scripts in the initrd and see what turns up.

NeilBrown




> 
> 
> My diff findings between the local copy of mdadm.conf and the initramfs's copy pasted at:
> http://debian.pastebin.com/5VNnd9g1
> 
> 
> Thanks for your help.
> 
> 
> -M
>  		 	   		  
