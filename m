From: Samuel Tardieu <sam@rfc1149.net>
Subject: Re: [RFC PATCH 2.6.23.1] md: add dm-raid1 read balancing
Date: Mon, 12 Nov 2007 00:36:46 +0100
Message-ID: <87wsso4anl.fsf@willow.rfc1149.net>
References: <1194084522.1353.10.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Konstantin" == Konstantin Sharlaimov
>>>>> <konstantin.sharlaimov@gmail.com> writes:

Konstantin> This patch adds RAID1 read balancing to device mapper. A
Konstantin> read operation that is close (in terms of sectors) to a
Konstantin> previous read or write goes to the same mirror.

I am currently running it on top of a 2.6.24-rc2 kernel and it works
fine so far.

  Sam
-- 
Samuel Tardieu -- sam@rfc1149.net -- http://www.rfc1149.net/

