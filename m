From: Luca Berra <bluca@comedia.it>
Subject: Re: [PATCH] enable auto=yes by default when using udev
Date: Tue, 4 Jul 2006 12:47:03 +0200
Message-ID: <20060704104658.GC8357@percy.comedia.it>
References: <20060702224549.GD12733@percy.comedia.it> <17576.21342.685662.432117@cse.unsw.edu.au> <44AA42F6.8070307@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <44AA42F6.8070307@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Jul 04, 2006 at 02:29:10PM +0400, Michael Tokarev wrote:
>Why to test for udev at all?  If the device does not exist, regardless
because udev whas what was giving me pains :)

>if udev is running or not, it might be a good idea to try to create it.
>Because IT IS NEEDED, period.  Whenever the operation fails or not, and
i believe we can set autof to 2 by default.

>whenever we fail if it fails or not - it's another question, and I think
>that w/o explicit auto=yes, we may ignore create error and try to continue,
>and with auto=yes, we fail on create error.
we need to distinguish between explicit auto=no, explicit auto=yes and
implicit auto=yes for this. maybe this is overkill

>as it does now.  If /dev/whatever exist, use it. If not, create it (unless,
>perhaps, auto=no is specified) directly with proper mknod("/dev/mdX"), but
>don't try to use some temporary names in /dev or elsewhere.
agreed!

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
