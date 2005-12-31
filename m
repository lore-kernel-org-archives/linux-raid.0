From: Luca Berra <bluca@comedia.it>
Subject: Re: hard drives with "variable"  device names - mdadm raid assembly options setup
Date: Sat, 31 Dec 2005 13:01:23 +0100
Message-ID: <20051231120123.GA30572@percy.comedia.it>
References: <200512300908.19390.mlaks@verizon.net> <87d5jep027.fsf@rimspace.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87d5jep027.fsf@rimspace.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Dec 31, 2005 at 11:44:32AM +1100, Daniel Pittman wrote:
>DEVICE /dev/hd*
>DEVICE /dev/sd*
>
i really find
DEVICE partitions
to be more useful than shell patterns.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
