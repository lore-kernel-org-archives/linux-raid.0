From: Luca Berra <bluca@comedia.it>
Subject: Re: root filesystem copy ro raid
Date: Mon, 17 Feb 2003 09:21:23 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030217082123.GD13245@percy.comedia.it>
References: <84BB6E1F4E011742AFB186D469FDEA9A015BD5@fastterminal.fasttrack.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <84BB6E1F4E011742AFB186D469FDEA9A015BD5@fastterminal.fasttrack.net.au>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Feb 17, 2003 at 04:39:23PM +1100, Lewis Shobbrook wrote:
>The howto's use cp -a or pipe to cpio -pm .

sigh....

cd /source
find . -xdev -print0 | cpio -padum0 -v --sparse /target

-v and --sparse are optional

L.
-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
