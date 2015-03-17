From: Chris Murphy <chris@colorremedies.com>
Subject: chunk size K, KB, KiB
Date: Tue, 17 Mar 2015 11:48:31 -0600
Message-ID: <CAJCQCtQ-JQNGNEyzxka2H4rRXfFsBv5WZG=oU95maW+q=T3x+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> man mdadm:
> -c, --chunk=
>    Specify chunk size of kibibytes. The default when creating an array is
>    512KB.
[...snip...]
>A suffix of 'M' or 'G' can be given to indicate Megabytes or Gigabytes respectively.

Is this actually 512KiB as in 1024 512 byte sectors? Or is is 1000 512
byte sectors? I suppose either one is plausible.

SNIA's DDF reference says strip_size (synonym for chunk and stripe depth) is

Table 27 (following page) [1], see the strip_size examples. All of
those values are clearly base 2 values, but they're wrongly labeled
with the base 10 SI prefix.

Therefore I'm pretty sure the mdadm man page is correct saying
"Specify chunk size of kibibytes" and subsequently should instead use
512KiB and 64KiB respectively.

[1]
http://www.snia.org/sites/default/files/SNIA_DDF_Technical_Position_v2.0.pdf

-- 
Chris Murphy
