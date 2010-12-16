From: "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>
Subject: raid0 to raid10 takeover bug
Date: Thu, 16 Dec 2010 14:50:42 +0000
Message-ID: <BE2BFE91933D1B4089447C644860408066B83882@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I would like to report a bug connected with raid0 to raid10 takeover operation.
When we add a spare drive to array after takeover, recovery process has been triggered but it is not finish- it stops at about 90%.
"resync" process is in uninterruptable sleep state (D). Deadlock?
It is reproducible on native and imsm metadata.
Any ideas, suggestions?

Regards- Krzysztof
