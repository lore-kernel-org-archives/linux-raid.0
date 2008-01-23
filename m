From: Wolfgang Denk <wd@denx.de>
Subject: Re: identifying failed disk/s in an array.
Date: Wed, 23 Jan 2008 15:00:11 +0100
Message-ID: <20080123140011.628FB2430C@gemini.denx.de>
References: <47972CCD.5010600@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: Your message of "Wed, 23 Jan 2008 12:02:21 GMT."
             <47972CCD.5010600@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Tomasz Chmielewski <mangoo@wpkg.org>, Michael Harris <michael.harris@rmit.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In message <47972CCD.5010600@dgreaves.com> you wrote:
>
> And/or use smartctl to look up the make/model/serial number and look at the
> drive label. I always do this to make sure I'm pulling the right drive (also
> useful to RMA the drive)

Or, probblay even faster, do a "ls -l /dev/disk/by-id" (assuming you
are using udev).

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Command, n.:
            Statement presented by a human and accepted by a computer
in such a manner as to make the human feel as if he is in control.
