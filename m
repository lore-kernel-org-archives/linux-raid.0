From: Luca Berra <bluca@comedia.it>
Subject: Re: MD uses wrong disks to assemble an array?
Date: Mon, 14 Jun 2004 10:40:59 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040614084058.GA18682@percy.comedia.it>
References: <40C92569.8070808@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <40C92569.8070808@tls.msk.ru>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jun 11, 2004 at 07:22:17AM +0400, Michael Tokarev wrote:
>Yes, START_ARRAY (used by raidtools) is deprecated,
>but I understand also that mdadm in such a situation
>will refuse to bring the array up, because the
>GUUIDs will be different.
it depends on what you tell mdadm to do.
i created mdassemble for this very purpose, it scans a configuration
file where you should put the uids for your root md component,
in this case mdassemble will bring your root array up, even if degraded.

regards,
L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
