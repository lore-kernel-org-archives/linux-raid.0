From: Wolfgang Denk <wd@denx.de>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Tue, 29 Jan 2013 00:31:19 +0100
Message-ID: <20130128233119.1476E203AD5@gemini.denx.de>
References: <20130127192656.634892005AD@gemini.denx.de> <20130128173704.GA2329@lazy.lzy> <20130128190035.D943A294BAB@gemini.denx.de> <20130128191041.8E962200607@gemini.denx.de> <20130128192256.GB13803@lazy.lzy> <20130128201947.2B615200607@gemini.denx.de> <20130128204422.GA14115@lazy.lzy> <6D287BCE-96EB-4F91-AC5A-34CD7AD2C68D@colorremedies.com> <1CEFA702-4512-40C1-ABE4-0FF7F42D9F44@colorremedies.com> <20130128230319.06A53203AD5@gemini.denx.de> <19DB9CE1-E7A9-4812-B3C8-1E59AD6ADA67@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <19DB9CE1-E7A9-4812-B3C8-1E59AD6ADA67@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Chris Murphy,

In message <19DB9CE1-E7A9-4812-B3C8-1E59AD6ADA67@colorremedies.com> you wrote:
> 
> > The last time bbefore the update to Fedora 18, all systems were
> > running Fedora 17 (with almost all updates installed), and there were
> > no problems.
> 
> Yes but what kernel version and mdadm? Right now 3.7.3-104 is stable kernel for Fedora 17, and 3.2.6-8 for mdadm for Fedora 17. So saying Fedora 17 tells not very much.

It was mdadm-3.2.6-1.fc17.x86_64 before on all 3 systems.

Two machines were running kernel version 3.6.10-2.fc17.x86_64, the
third one 3.6.11-1.fc17.x86_64

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
"What if" is a trademark of Hewlett Packard, so stop using it in your
sentences without permission, or risk being sued.
