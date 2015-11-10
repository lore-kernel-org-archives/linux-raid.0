From: Mathias Mueller <raidfail@gmx.de>
Subject: Re: broken raid level 5 array caused by user error
Date: Tue, 10 Nov 2015 09:37:21 +0100
Message-ID: <420c63e0400e6d3f50b794e64f6a8d96@pingofdeath.de>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56410C67.2090202@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Phil,

sadly, my ssh-session died while hexdumping over night, but I post what 
I got (restarted the processes anyway):

> dd if=/dev/sdd1 bs=1M count=1M |hexdump -C |grep -E '[048c]30  .+  53 
> ef'

sdb1:
http://pastebin.com/ERehrYYR

sdc1:
http://pastebin.com/WMpRtPs5

sdd1:
http://pastebin.com/5QxGuGGY

sde1:
http://pastebin.com/CAC8Pkt9


Best regards

Mathias
