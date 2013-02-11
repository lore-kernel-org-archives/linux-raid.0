From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: raid/device failure
Date: Mon, 11 Feb 2013 00:55:40 -0700
Message-ID: <201302110055.40801.thomas@fjellstrom.ca>
References: <201302101827.36116.thomas@fjellstrom.ca> <511863F7.2090108@fnarfbargle.com>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <511863F7.2090108@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On February 10, 2013, Brad Campbell wrote:
> On 11/02/13 09:27, Thomas Fjellstrom wrote:
> > sd 0:0:7:0: [sdh]  Add. Sense: Information unit iuCRC error detected
> 
> The CRC error there is the key. Check your cables, backplane & PSU.
> 

Very good to know. Thank you. :) Google had hinted the same thing. I've gone 
into the machine and made sure everything was snug, just in case it was a lose 
cable or connection on the backplane.

I've --add'ed the drive back to the array. I think that should make a simple 
test to see if anything reallocates. After that, I'll try some more read and 
mixed read-write tests to see if the error's going to pop up again, but so far 
after a few hours, not even a single warning*.

Should the problem come back, I'll follow up with a power test, then some 
cable tests. Since it seemed that it was always erroring out on the same drive 
(not 100% sure, but it seems like it), and if its not likely a drive problem, 
it may be one SFF-8087 breakout cable, then swapping the cables should change 
which drive it happens to, if it does I should know its the cable.

* except for this: "[ 1052.626900] The scan_unevictable_pages sysctl/node-
interface has been disabled for lack of a legitimate use case.  If you have 
one, please send an email to linux-mm@kvack.org." and I have absolutely no 
idea what caused that at this point and time. Also don't think its applicable.


-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
