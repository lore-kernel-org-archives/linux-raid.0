From: Tim Moore <linux-raid@nsr500.net>
Subject: Re: Scrub?
Date: Fri, 06 Aug 2004 13:29:41 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4113EA35.2020807@nsr500.net>
References: <1074.24.117.72.28.1091815644.squirrel@mail.oversimplified.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1074.24.117.72.28.1091815644.squirrel@mail.oversimplified.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

No.  Try 'e2fsck -c -c' if unmounted or 'badblocks -nsv' if mounted on the 
individual physical devices.

Derek Listmail Acct wrote:
> Many of the hardware raid controllers I've used have the ability to run a
> 'scrub' on an array.  Is there a way to do this on a linux software raid 5
> array?
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
