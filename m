From: Phil Turmel <philip@turmel.org>
Subject: Re: broken raid level 5 array caused by user error
Date: Tue, 10 Nov 2015 16:11:58 -0500
Message-ID: <56425D9E.5090204@turmel.org>
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
 <63e6dd8089ebeabf27e3419255e29958@pingofdeath.de>
 <56420D34.5070204@turmel.org>
 <1fbbbaa43fd856c740de67179a078b8a@pingofdeath.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1fbbbaa43fd856c740de67179a078b8a@pingofdeath.de>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias Mueller <raidfail@gmx.de>
Cc: Linux raid <linux-raid@vger.kernel.org>, linux-raid-owner@vger.kernel.org
List-Id: linux-raid.ids

On 11/10/2015 04:02 PM, Mathias Mueller wrote:
> /dev/md0 has unsupported feature(s): FEATURE_C16 FEATURE_C17 FEATURE_C18
> FEATURE_C19 FEATURE_C21 FEATURE_C22 FEATURE_C23 FEATURE_C25 FEATURE_C27
> FEATURE_C28 FEATURE_I29 FEATURE_R29
> e2fsck: Get a newer version of e2fsck!

None of the feature bits are documented to exist.  The choice of first
drive must be wrong.

> I created the array with this command:
> 
> mdadm --create --assume-clean -l5 -n4 --chunk 64 --data-offset 1024
> --metadata 1.2 /dev/md0 ......
> 
> This both combinations

Well, I gave you *four* combinations for order, and two suggestions for
chunk size.  Eight combinations to try.

> The devices names are now different, but I adjusted the names by serial
> numbers as you told.

Ok.

> Also mdadm --examine on on of the drives tells "Data offset: 2048
> Sectors" when mdadm --create --data-offset 1024 is used. Is this normal?
> It's confusing me (using --data-offset 2048 on creation gives "Data
> offset: 2048 Sectors").

mdadm must be enforcing a minimum offset.

Phil

