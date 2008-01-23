From: David Greaves <david@dgreaves.com>
Subject: Re: identifying failed disk/s in an array.
Date: Wed, 23 Jan 2008 12:02:21 +0000
Message-ID: <47972CCD.5010600@dgreaves.com>
References: <479765CF.A931.0080.0@ems.rmit.edu.au> <4796E529.7030502@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4796E529.7030502@wpkg.org>
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: Michael Harris <michael.harris@rmit.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tomasz Chmielewski wrote:
> Michael Harris schrieb:
>> i have a disk fail say HDC for example, i wont know which disk HDC is
>> as it could be any of the 5 disks in the PC. Is there anyway to make
>> it easier to identify which disk is which?.
> 
> If the drives have any LEDs, the most reliable way would be:
> 
> dd if=/dev/drive of=/dev/null
> 
> Then look which LED is the one which blinks the most.

And/or use smartctl to look up the make/model/serial number and look at the
drive label. I always do this to make sure I'm pulling the right drive (also
useful to RMA the drive)


David
