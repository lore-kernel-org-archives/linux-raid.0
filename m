From: Luca Berra <bluca@comedia.it>
Subject: Re: Tools for Hardware Raid?
Date: Mon, 28 Dec 2009 22:27:12 +0100
Message-ID: <20091228212712.GC2224@maude.comedia.it>
References: <1262014433.25079.212.camel@vibe>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1262014433.25079.212.camel@vibe>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Dec 28, 2009 at 10:33:53AM -0500, Rick Bragg wrote:
>Hi,
>
>Since my latest disaster was caused be me not monitoring raid disks, I
>was wondering about tools for monitoring hardware based raid systems?
>
>I have a Dell 1900 with a perc5 raid controller
>
># lspci
>02:0e.0 RAID bus controller: Dell PowerEdge Expandable RAID controller 5

actually this should be a rebranded LSI megaraid
you can use the megacli tool (www.lsi.com) to monitor the array status.
i use a nagios plugin around it
L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
