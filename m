From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: small mdadm issue under debian
Date: Fri, 6 Nov 2009 14:18:56 -0700
Message-ID: <200911061418.56978.tfjellstrom@shaw.ca>
References: <200910290124.59090.tfjellstrom@shaw.ca> <19182.15837.879963.989788@notabene.brown>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19182.15837.879963.989788@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun November 1 2009, you wrote:
> On Thursday October 29, tfjellstrom@shaw.ca wrote:
> > I've been trying to get mdadm to auto assemble my raid array for a
> > while now, and as I'm trying to test which kernels give me back some
> > performance (testing 2.6.26 right now), I find that with this kernel,
> > its happily auto assembling my 1.1 versioned metadata array. 3.6.30
> > does not, nor does .31 or .32 for that matter. Same version of mdadm,
> > for some reason, when the mdadm-raid init script is run, it fails to
> > assemble the raid array I've specified in mdadm.conf. And again, it
> > automagically works with 2.6.26.
> >
> > color me confused.
> 
> Me too.
> 
> Can you run the "mdadm" command that fails by hand and have it still
> fail?
> If so, can you run it with "-v" and post the result.
> Or maybe edit the script to add -v and see what it says.

I meant to get around to this, but it seems I had to "fast track" the 
building of my new server, and it necessitated two new hard disks (raid0) 
and a new debian install. And so far, it seems both the raid1 root, and 
raid5 data arrays are properly building and mounting.

Sorry for the noise. If I see it again I'll try and figure it out.

The only hint I might have is that it might have fixed itself when I added 
raid5 to the initramfs modules file. Not sure though.

> NeilBrown
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
