From: Wolfgang Denk <wd@denx.de>
Subject: Re: Optimize RAID0 for max IOPS?
Date: Wed, 19 Jan 2011 08:04:32 +0100
Message-ID: <20110119070432.7EC462FC@gemini.denx.de>
References: <20110118210112.D13A236C@gemini.denx.de> <AANLkTimzwgg_Htj4rMxjdjhMQHExeWOqzd5Puu9KbXug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <AANLkTimzwgg_Htj4rMxjdjhMQHExeWOqzd5Puu9KbXug@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Roberto Spadim,

In message <AANLkTimzwgg_Htj4rMxjdjhMQHExeWOqzd5Puu9KbXug@mail.gmail.com> you wrote:
>
> try partitioning all hard drives and make many paritions and make raid
> on each one
> another way could be a lvm over mdxxx and try to partition it (can lvm
> be partitioned?)

I do not intend to use any partitions.  I will use LVM on the full
device /dev/mdX, and then use logical volumes.


Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
What was sliced bread the greatest thing since?
