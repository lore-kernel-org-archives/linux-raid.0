From: Luca Berra <bluca@comedia.it>
Subject: Re: Problem with mdadm and raidstart
Date: Fri, 2 Apr 2004 00:29:48 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040401222947.GB31662@percy.comedia.it>
References: <20040401192015.40822.qmail@web14522.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040401192015.40822.qmail@web14522.mail.yahoo.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Apr 01, 2004 at 11:20:15AM -0800, Don Jessup wrote:
>   I have been testing disk failures with RAID5.   I have problems that I
>  have run into that happens with raidstart and mdadm. 
use the --scan and --super-minor or --uuid parameters to mdadm.
you will need to edit mdadm.conf

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
