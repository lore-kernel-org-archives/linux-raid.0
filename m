From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: RAID 16?
Date: Thu, 2 Feb 2006 19:42:17 +0100
Message-ID: <drtjq9$4le$1@sea.gmane.org>
References: <43E19FAB.4000603@cogweb.net> <pan.2006.02.02.16.17.03.859560@smurf.noris.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Matthias Urlichs <smurf@smurf.noris.de> wrote:
> Hi, David Liontooth wrote:
>>   * define 4 pairs of RAID 1 with an 8-port 3ware 9500S card * the OS will
> Hmm. You'd have eight disks, five(!) may fail at any time, giving you

Four, isn't it?
RAID6 covers the failure of 2 of the underlying RAID1s, which, in turn,
means failures of 2 disks each, so four.
Sometimes even 5, yes - given the right ones fail.


regards
   Mario
-- 
We are the Bore. Resistance is futile. You will be bored.

