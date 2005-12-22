From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: First RAID Setup
Date: Thu, 22 Dec 2005 09:00:46 -0500
Message-ID: <43AAB18E.70009@tmr.com>
References: <0481A62A3E95A044AC20A1A45899645C06B02F4A@glc-mail-1.tessco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0481A62A3E95A044AC20A1A45899645C06B02F4A@glc-mail-1.tessco.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Callahan, Tom" <CallahanT@tessco.com>
Cc: 'Andargor The Wise' <andargor@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Callahan, Tom wrote:

>You "should" have a designated spare for RAID-5.
>
>Not sure why you have 3 disks for each RAID1, RAID1 is mirror, and unless
>the third drive is a spare, it is not needed.
>
>Thanks,
>Tom Callahan
>  
>
Why would you have a hot spare? In RAID-1 if one drive failed you would 
copy the full set of data to the "spare" so you know what to copy, 
another mirror can help your read performance under heavy load. You get 
the same protection as a hot spare, it's online if you need it, it 
covers the case where two drives fail... what's not to like? ;-)

If a third drive is justified, I see no reason to keep it as a spare 
rather than a live mirror in RAID-1.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

