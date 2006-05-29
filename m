From: Luca Berra <bluca@comedia.it>
Subject: Re: problems with raid=noautodetect
Date: Mon, 29 May 2006 10:54:54 +0200
Message-ID: <20060529085453.GA708@percy.comedia.it>
References: <4471B188.3060400@umit.at> <17522.15774.526526.244768@cse.unsw.edu.au> <20060526075308.GC8203@percy.comedia.it> <17530.30389.862288.268450@cse.unsw.edu.au> <447AB301.6050107@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <447AB301.6050107@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, May 29, 2006 at 12:38:25PM +0400, Michael Tokarev wrote:
>Neil Brown wrote:
>> On Friday May 26, bluca@comedia.it wrote:
>I'd suggest the following.
>
>"All the other devices" are included or excluded from the list of devices
>to consider based on the last component in the DEVICE line.  Ie. if it
>ends up at !dev, all the rest of devices are included.  If it ends up at
>dev (w/o !), all the rest are excluded.  If memory serves me right, it's
>how squid ACLs works.
>
>There's no need to introduce new keyword.  Given this rule, a line

as i said the new keyword is to warn on configurations that do not
account for changing device-ids, and if we change the syntax a new
keyword would make it clearer. In case the user tries to use a new
configuration on an old mdadm.

>The only possible issue I see here is that with udev, it's possible to
>use, say, /dev/disk/by-id/*-like stuff (don't remember exact directory
>layout) -- symlinked to /dev/sd* according to the disk serial number or
>something like that -- for this to work, mdadm needs to use glob()
>internally.

uhm
i think that we would better translate any device found on a DEVICE (or
DEVICEFILTER) line to the corresponding major/minor number and blacklist
based on that.
nothing prevents someone to have an udev rule that creates a device
node, instead of symlinking.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
