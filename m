From: Phil Turmel <philip@turmel.org>
Subject: Re: mdadm vs zfs for home server?
Date: Mon, 27 May 2013 19:50:25 -0400
Message-ID: <51A3F141.9050505@turmel.org>
References: <20130527180912.GA6068@septictank.raw-sewage.fake> <51A3DF2B.7070200@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51A3DF2B.7070200@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Matt Garman <matthew.garman@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,

On 05/27/2013 06:33 PM, Stan Hoeppner wrote:

[trim /]

> WRT to scheduled scrubbing, I don't do it, I don't believe in it.  While
> it may give you some piece of mind, this simply puts extra wear on the
> drives.  RAID6 it is self healing, right, so why bother with scrubbing?
>  It's a self fulfilling prophecy kinda thing--the more you scrub, the
> more likely you are to need to scrub due to the wear of previous scrubs.
>  I don't do it any arrays.  It just wears the drives out quicker.

I'm going to go out on a limb here and disagree with Stan.  I do "check"
scrubs in lieu of SMART long self tests, on a weekly basis.  They both
read the entire drive--necessary to uncover "pending" sectors.  But a
check scrub will rewrite that pending sector to immediately turn it into
a relocation, if it cannot be fixed.  An enterprise drive's better error
rate (an order of magnitude better, from the specs I've read) reduces
the need to do any scrub, but if you are doing long self tests anyways,
you should scrub.

In my humble opinion, *relocations* are the key indicator of approaching
drive failure, and they won't happen if pending sectors don't get rewritten.

Arguably, if you want to be anal, one could analyze the error reports
from an long self test, and "scrub" just the sectors with errors.  I
find that to be an unnecessary complication.

Phil
