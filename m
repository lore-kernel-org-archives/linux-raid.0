From: Luca Berra <bluca@comedia.it>
Subject: Re: disk failure and badblocks
Date: Sat, 22 Nov 2003 15:12:18 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031122141218.GF12265@percy.comedia.it>
References: <1069489341.4351.5.camel@binkley>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1069489341.4351.5.camel@binkley>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Nov 22, 2003 at 03:22:21AM -0500, seth vidal wrote:
>My major wonder is will badblocks be effective for looking for a medium
>error?
only if you can disable the disk onboard cache :)
a long time ago i changed badblocks write mode algo to write a pattern
to the full disk THEN check it, instead of write-block, check, next
block which was a victim of the cache. Pity i lost that patch :)

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
