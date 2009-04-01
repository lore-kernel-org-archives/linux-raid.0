From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Why do I need 4 disks for a raid6?
Date: Wed, 01 Apr 2009 09:08:09 -0700
Message-ID: <49D39169.2050705@zytor.com>
References: <87ljr4hsk9.fsf@frosties.localdomain> <20090318121825.GL32416@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090318121825.GL32416@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andre Noll wrote:
> 
>> So back to my original question: Why does the kernel require 4 disks
>> for a raid6 instead of allowing 3?
> 
> Dunno. Maybe Dan, Neil or HPA can tell the reason for imposing this
> limitation.
> 

It's very simple: it avoids an ugly corner case in the RAID-6
computation code.  Rather than inserting special code (and verifying it,
etc.) to deal with the 3-disk RAID-6 degenerate case, it was easier to
just not permit it.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

