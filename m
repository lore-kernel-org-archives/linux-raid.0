From: Luca Berra <bluca@comedia.it>
Subject: Re: bad /proc/mdstat message
Date: Mon, 12 Jan 2004 20:38:06 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040112193805.GB1174@percy.comedia.it>
References: <Pine.GSO.4.31.0401121226350.29377-100000@staff2.cso.uiuc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.31.0401121226350.29377-100000@staff2.cso.uiuc.edu>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 12, 2004 at 12:28:37PM -0600, Sharif Islam wrote:
>I am getting the following message:
>mdadm: bad /proc/mdstat line starts : Event:
>
>I wasn't able to figure out the reason. My array is acting normal and
>/proc/mdstat looks ok to me.
>
># cat /proc/mdstat
>Personalities : [linear] [raid0]
>read_ahead 1024 sectors
>Event: 1
where does this line come from?
are you running a vanilla or patched kernel? which version?

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
