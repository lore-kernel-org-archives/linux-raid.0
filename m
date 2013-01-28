From: Wolfgang Denk <wd@denx.de>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Mon, 28 Jan 2013 07:39:52 +0100
Message-ID: <20130128063952.E3BD7258787@gemini.denx.de>
References: <20130127192656.634892005AD@gemini.denx.de> <5105DD72.6080909@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <5105DD72.6080909@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Brad Campbell,

In message <5105DD72.6080909@fnarfbargle.com> you wrote:
>
> Massive mismatch counts are indicative of an insidious problem further 
> down the storage stack. Check your drivers, cards, cables and PSU.

That's why I'm asking. The hardware has not been changed at all, and
has been running reliably for many months even years. No such problem
has been observed ever before, but now it happens at the first check
operation after switching to Fedora 18, simultaneous on all systems.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Being schizophrenic is better than living alone.
