From: Wolfgang Denk <wd@denx.de>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Mon, 28 Jan 2013 11:27:41 +0100
Message-ID: <20130128102741.E3473282D2B@gemini.denx.de>
References: <20130127192656.634892005AD@gemini.denx.de> <5105D0EA.7080100@turmel.org> <6BCDA3B1-C137-486D-A45D-55912207AF3C@colorremedies.com> <20130128063656.BB93524E481@gemini.denx.de> <7BE0F80F-4730-41C0-80D0-AFD7996FDB4C@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <7BE0F80F-4730-41C0-80D0-AFD7996FDB4C@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Chris,

In message <7BE0F80F-4730-41C0-80D0-AFD7996FDB4C@colorremedies.com> you wrote:
> 
> And what does fsck.ext4 -f -n get you?

No errors on any of the affected file systems.

> Switching to Fedora 18 means many things have changed so it's
> harder to find out, if software, what's causing it. Is it kernel
> itself, is it md, is it the HBA driver?

Agreed. But as there are at least 2 different HBA brands involved it
appears we can exclude this part.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
The world is no nursery.                              - Sigmund Freud
