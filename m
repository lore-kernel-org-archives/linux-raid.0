From: Luca Berra <bluca@comedia.it>
Subject: Re: Adding a mirror to a RAID1 Device
Date: Tue, 25 Nov 2003 23:45:34 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031125224533.GA19282@percy.comedia.it>
References: <16323.732.390200.935640@notabene.cse.unsw.edu.au> <Pine.LNX.4.44.0311251557120.1140-100000@redhat1.mmaero.com> <16323.53577.411117.6469@notabene.cse.unsw.edu.au> <3FC3D27A.5010105@eglifamily.dnsalias.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3FC3D27A.5010105@eglifamily.dnsalias.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Nov 25, 2003 at 03:06:50PM -0700, Dan Egli wrote:
>-----BEGIN PGP SIGNED MESSAGE-----
>Hash: SHA1
>
>Neil Brown wrote:
>
>|
>| all is done.... unless you are using raidstart, but that is
>| universally a mistake.
>
>But all linux distributions I've used, save perhaps gentoo, DO use
>raidstart with /etc/raidtab. How do you configure it so the kernel
>assembles the array for you? /etc/fstab?
>
for mandrake linux you can use my packages:
http://www.comedia.it/~bluca/cooker/lvm2/
(you only need initscripts, you might need the mdadm there and mkinitrd,
if you have root raid)

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
