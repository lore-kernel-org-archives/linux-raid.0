From: Luca Berra <bluca@comedia.it>
Subject: Re: Can you IMAGE Mirrored OS Drives?
Date: Wed, 16 Aug 2006 09:38:54 +0200
Message-ID: <20060816073854.GA7356@percy.comedia.it>
References: <44E250CD.5040308@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <44E250CD.5040308@aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Aug 15, 2006 at 06:55:09PM -0400, andy liebman wrote:
>I will post my recipe here tomorrow for others to see -- maybe it will 
>help somebody else. I just want to edit a few things to clarify before I 
>post it. Some of the gotchas were were amusing -- like I couldn't run 
>LILO on degraded raid1 arrays, and running "mkinitrd" from within 
damn, could you open a bug on qa.mandriva.com, so we will remember to
fix it?
>Mandriva 2006 produces gzipped initrd files, but running "mkinitrd" by 
>chrooting in from a LIVE CD produces initrd files that needs cpio to 
>decompress and read it.
actually up to kernel 2.6.12-18mdk we defaulted to gzipped cramfs
initrd. now the default is initramfs.

>clone SINGLE OS drives. Can you clone RAIDS? It would mean, of course, 
you can certainly clone raids.

>that the UUIDs would be the same on each system. Is that bad? Is there 
>any risk here?
The only risk is if you ever move one disk from one machine to another.
To work around this you can change the uuid by recreating the array with
mdadm, but you would have to regenerate the initrd and fight again with
lilo :(

>-- I know there was a lot of discussion on the list a while back about 
>whether or not to mirror SWAP space. Was there ever any conclusion? It 
yes, with kernel 2.2 mirroring swap led to deadlocks under memory
pressure. but with modern kernels the only issue that would prevent you
to mirror swap is masochism.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
