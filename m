From: Luca Berra <bluca@comedia.it>
Subject: Re: mkraid hangs system
Date: Wed, 12 May 2004 21:00:53 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040512190053.GB7006@percy.comedia.it>
References: <200405121819.i4CIJO60013175@socrates.Berkeley.EDU>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200405121819.i4CIJO60013175@socrates.Berkeley.EDU>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, May 12, 2004 at 11:21:32AM -0700, Arnab Chowdry wrote:
>I suspect it's some sort of corruption on the drives because of the original
>crash that the RAID layer can't handle...so I'm wondering if there's some
>way to wipe the drives completely and start from scratch again? Or if there
>are any other suggestions?
>
>I'm using Mandrake 9.2 with raidtools installed using urpmi.
>
you could dd if=/dev/zero of=/dev/your/disk,
or you can just try removing the superblock by installing mdadm from
contribs and using the --zero-superblock option.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
