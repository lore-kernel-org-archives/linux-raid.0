From: Matthias Urlichs <smurf@smurf.noris.de>
Subject: Re: RAID 16?
Date: Thu, 02 Feb 2006 21:34:02 +0100
Message-ID: <pan.2006.02.02.20.34.02.59627@smurf.noris.de>
References: <43E19FAB.4000603@cogweb.net> <pan.2006.02.02.16.17.03.859560@smurf.noris.de> <drtjq9$4le$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, Mario 'BitKoenig' Holbe wrote:

>> Hmm. You'd have eight disks, five(!) may fail at any time, giving you
> 
> Four, isn't it?
> RAID6 covers the failure of 2 of the underlying RAID1s, which, in turn,
> means failures of 2 disks each, so four. Sometimes even 5, yes - given the
> right ones fail.

No -- with any four failed disks you still do not have a single point of
failure. Only when you take out two RAID1 pairs and one disk in a third
pair does the second disk in that third pair become a SPOF.

-- 
Matthias Urlichs   |   {M:U} IT Design @ m-u-it.de   |  smurf@smurf.noris.de
Disclaimer: The quote was selected randomly. Really. | http://smurf.noris.de
 - -
Man created God in his own image.


