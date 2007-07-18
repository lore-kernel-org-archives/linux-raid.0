From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Raid array is not automatically detected.
Date: Wed, 18 Jul 2007 14:56:39 -0400
Message-ID: <469E6267.9000107@tmr.com>
References: <4697E231.3070906@hp.com> <4698D4FC.2060100@tmr.com> <Pine.LNX.4.64.0707140952440.31528@p34.internal.lan> <469B7E75.3030907@hp.com> <469B8D05.1080003@dgreaves.com> <469E2626.30204@hp.com> <469E35ED.3040500@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <469E35ED.3040500@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Bryan Christ <bryan.christ@hp.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

David Greaves wrote:
>
> See where it says 'component' ? :)
>
> I wish mdadm --detail and --examine were just aliases and the output 
> varied according to whether you looked at a component (eg /dev/sda1) 
> or an md device (/dev/md0)
>
> I get that wrong *all* the time...

Neil, if you will take that as a suggestion, you can take this as a 
second. While I have learned to use the correct option most of the time, 
this is a case where the software can make an unambiguous decision to 
avoid the human having to stop and think which option is appropriate.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

