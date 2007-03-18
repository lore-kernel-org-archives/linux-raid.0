From: Wolfgang Denk <wd@denx.de>
Subject: Re: Data corruption on software raid.
Date: Sun, 18 Mar 2007 16:17:53 +0100
Message-ID: <20070318151753.7A725353A42@atlas.denx.de>
References: <20070318131606.GJ6063@freshdot.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: Your message of "Sun, 18 Mar 2007 14:16:06 +0100."
             <20070318131606.GJ6063@freshdot.net>
Sender: linux-raid-owner@vger.kernel.org
To: Sander Smeenk <ssmeenk@freshdot.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In message <20070318131606.GJ6063@freshdot.net> you wrote:
> 
> But what amazes me is that no media errors can be detected by doing a
> write/read check on every sector of the disk with mke2fs, and no data
> corruption occurs when moving data to the set locally!
> 
> Can anyone shed some light on what i can try next to isolate what is
> causing all this?  It's not the software raid code, the IDE set is

If it happens only with downloaded data, you may see data corruption
in the NIC hardware and/or driver. Try using another network card
(other vendor, other type).

Another possible culprit is memory - you may see memory errors  under
certain usage patterns. Make sur to run a memory test, and/or try
changing RAM.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH, HRB 165235 Munich, CEO: Wolfgang Denk
Office:  Kirchenstr. 5,       D-82194 Groebenzell,            Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Time is an illusion perpetrated by the manufacturers of space.
