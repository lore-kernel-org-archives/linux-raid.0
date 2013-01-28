From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Mon, 28 Jan 2013 16:13:41 -0700
Message-ID: <19DB9CE1-E7A9-4812-B3C8-1E59AD6ADA67@colorremedies.com>
References: <20130127192656.634892005AD@gemini.denx.de> <20130128173704.GA2329@lazy.lzy> <20130128190035.D943A294BAB@gemini.denx.de> <20130128191041.8E962200607@gemini.denx.de> <20130128192256.GB13803@lazy.lzy> <20130128201947.2B615200607@gemini.denx.de> <20130128204422.GA14115@lazy.lzy> <6D287BCE-96EB-4F91-AC5A-34CD7AD2C68D@colorremedies.com> <1CEFA702-4512-40C1-ABE4-0FF7F42D9F44@colorremedies.com> <20130128230319.06A53203AD5@gemini.denx.de>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130128230319.06A53203AD5@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Jan 28, 2013, at 4:03 PM, Wolfgang Denk <wd@denx.de> wrote:

> Dear Chris,
> 
> In message <1CEFA702-4512-40C1-ABE4-0FF7F42D9F44@colorremedies.com> you wrote:
>> 
>> Actually it also needs to be reproduced as well. Wolfgang, the
>> arrays were created/running under what version of mdadm and kernel
>> the last time you did a check and there were no problems?
> 
> No. The arrays were created before the update, and were running fine
> by then.  The most recent of them was created under Fedora 17 - the
> other two are much older; it would take a bit of effort to find out
> when I created these, and with which exact versions.
> 
> The last time bbefore the update to Fedora 18, all systems were
> running Fedora 17 (with almost all updates installed), and there were
> no problems.

Yes but what kernel version and mdadm? Right now 3.7.3-104 is stable kernel for Fedora 17, and 3.2.6-8 for mdadm for Fedora 17. So saying Fedora 17 tells not very much.

> 
>> And now you're on Fedora 18, but the problem appeared with what
>> version of mdadm and kernel?
> 
> The problem showed up during the first check after updating to Fedora
> 18.  This is with:
> 
> 	kernel-3.7.4-204.fc18.x86_64
> 	mdadm-3.2.6-12.fc18.x86_64

OK and the versions before that, that you know the problem was not occurring?


Chris Murphy