From: linux-raid@ied.com
Subject: Re: recovery of hosed raid5 array
Date: Sat, 11 Oct 2003 14:59:27 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <no.Yo.24973.N.nN.0310111457280@business.com>
References: <slrnbog9og.t0c.lunz@orr.homenet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <slrnbog9og.t0c.lunz@orr.homenet>
To: Jason Lunz <lunz@falooley.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


 Hi,

On Sat, 11 Oct 2003, Jason Lunz wrote:

> Date: Sat, 11 Oct 2003 15:52:40 +0000 (UTC)
> From: Jason Lunz <lunz@falooley.org>
> To: linux-raid@vger.kernel.org
> Subject: recovery of hosed raid5 array
> 
[...]
> Once the rebuild started, I noticed an email from smartd, saying that
> the _other_ drive on the Promise controller (/dev/hde) had had errors.
> So I foolishly checked it out with smartctl,

  Can you please share with us newbies why using "smartctl" 
in such situation is foolish, so we don't make the same 
mistake ?

  Thanks.

    John


[...]
> at which point everything
> went to hell. /dev/hde now clicks repeatedly and refuses to work for
> more than a minute or so, while /dev/hdg is partially destroyed from
> being re-added. The rebuild was 3-4% complete when hde died.


-- 
-- Gospel of Jesus' kingdom = saving power of God for all who believe --
                 ## To some, nothing is impossible. ##
