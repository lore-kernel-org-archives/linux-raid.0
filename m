From: "John Stoffel" <john@stoffel.org>
Subject: Re: RAID Issues - RAID10 working but with errors
Date: Thu, 2 Apr 2020 10:26:40 -0400
Message-ID: <24197.63008.837629.985226@quad.stoffel.home>
References: <d934f662-9fde-370b-bb4b-b92bd1730c96@websitemanagers.com.au>
        <832cb2b3-e9d3-e1a6-4ba5-f1f1b5d22b97@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <832cb2b3-e9d3-e1a6-4ba5-f1f1b5d22b97@thelounge.net>
Sender: linux-raid-owner@vger.kernel.org
To: Reindl Harald <h.reindl@thelounge.net>
Cc: Adam Goryachev <mailinglists@websitemanagers.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Reindl" == Reindl Harald <h.reindl@thelounge.net> writes:

Reindl> Am 02.04.20 um 04:28 schrieb Adam Goryachev:
>> Is there a method to determine if this is a HDD error (ie, 2 drives that
>> have errors) or a cabling issue (with just these two drives) or some
>> strange driver/motherboard issue?

Reindl> just try by start with the cheapest option: cables

Reindl> when nothing changes switch where they disks are connected and you will
Reindl> find out it's the motherboard when suddenly one drive that was completly
Reindl> fine before has the same issue

>> I notice in the output below MD is showing a number of bad blocks on the
>> drives, and logs suggest that the drives have run out of "spare" space
>> to re-allocate these to.

Reindl> from the moment on some software stack is telling you about
Reindl> bad blocks on drives run fast and replace fast

Hear hear!  When the drive is saying it's not happy... go get some
more now.  I wouldn't even question the badblocks you're seeing, that
means it's dying.

John
