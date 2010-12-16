From: Neil Brown <neilb@suse.de>
Subject: Re: raid0 to raid10 takeover bug
Date: Fri, 17 Dec 2010 10:24:57 +1100
Message-ID: <20101217102457.3ec8c8da@notabene.brown>
References: <BE2BFE91933D1B4089447C644860408066B83882@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BE2BFE91933D1B4089447C644860408066B83882@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 16 Dec 2010 14:50:42 +0000 "Wojcik, Krzysztof"
<krzysztof.wojcik@intel.com> wrote:

> Hi,
> 
> I would like to report a bug connected with raid0 to raid10 takeover operation.
> When we add a spare drive to array after takeover, recovery process has been triggered but it is not finish- it stops at about 90%.
> "resync" process is in uninterruptable sleep state (D). Deadlock?
> It is reproducible on native and imsm metadata.
> Any ideas, suggestions?
> 

I would start by getting a stack trace of all relevant processes, with by

  echo t > /proc/sysrq-trigger

or 
  cat /proc/XXXX/stack

Find out where the processes is waiting.

An 'D' stands for 'Disk wait' rather than 'Deadlock'.
It is a by if an anachronistic name as it is really any uninterruptible wait,
which can be for things other than waiting for Disk.

NeilBrown

