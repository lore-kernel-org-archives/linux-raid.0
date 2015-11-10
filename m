From: Mathias Mueller <raidfail@gmx.de>
Subject: Re: broken raid level 5 array caused by user error
Date: Tue, 10 Nov 2015 16:20:50 +0100
Message-ID: <63e6dd8089ebeabf27e3419255e29958@pingofdeath.de>
References: <15194c2e14b9a7c3431853dea9dc8b5e@pingofdeath.de>
 <alpine.DEB.2.02.1511091254290.24520@uplift.swm.pp.se>
 <5640A4B1.4050207@turmel.org>
 <07de4cd96f39ecb6154794d072ca12e7@pingofdeath.de>
 <5640B8AD.3030800@turmel.org>
 <ed5f0f3cde3f017eae97bab65c792983@pingofdeath.de>
 <d764bf541381927fa4183c9266fb3f5a@pingofdeath.de>
 <5640C38B.4060503@turmel.org>
 <a3a91665c4b7cdd70dacc7d8815cc365@pingofdeath.de>
 <56410C67.2090202@turmel.org>
 <420c63e0400e6d3f50b794e64f6a8d96@pingofdeath.de>
 <5641F749.2070804@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5641F749.2070804@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Phil,

Is it correct to use --data-offset=1024 when I want to set an offset of 
2048? At least a mdadm --examine on one of the devices shows the offset 
is set to 2048 when using --data-offset=1024.

With --data-offset=1024 and both chunk sizes (64 & 512) I have something 
like a success when using this two orders:

sde sdd sdb sdc
sde sdb sdd sdc

I'm getting:

e2fsck 1.41.12 (17-May-2010)
/dev/md0 has unsupported feature(s): FEATURE_C16 FEATURE_C17 FEATURE_C18 
FEATURE_C19 FEATURE_C21 FEATURE_C22 FEATURE_C23 FEATURE_C25 FEATURE_C27 
FEATURE_C28 FEATURE_I29 FEATURE_R29
e2fsck: Get a newer version of e2fsck!

So I guess I should try some newer fsck version (I'm back on the old 
machine with centos 6, the failed reshaping was done with the new 
machine with centos 7).

Thanks

Mathias

