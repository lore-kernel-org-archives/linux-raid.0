From: Jurriaan <thunder7@xs4all.nl>
Subject: Re: dd version I used is 5.2.1, but...
Date: Wed, 2 Mar 2005 08:45:33 +0100
Message-ID: <20050302074533.GA5347@middle.of.nowhere>
References: <4224C871.2000802@variant.ch>
Reply-To: Jurriaan <thunder7@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4224C871.2000802@variant.ch>
Sender: linux-raid-owner@vger.kernel.org
To: Nicola Fankhauser <nicola.fankhauser@variant.ch>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Nicola Fankhauser <nicola.fankhauser@variant.ch>
Date: Tue, Mar 01, 2005 at 08:54:25PM +0100
> hi
> 
> the version of dd I used is 5.2.1 (debian testing), but does anybody 
> have an idea regarding my performance question?
> 
- please group messages in the same thread, thank you.
- if there is no answer within a day, wait some more - not everybody is
  constantly reading this list, you know.
- wrt your question: how are those raid-controllers on your motherboard?
  If they are all connected through a single pci-bus, the speed is
  reasonable. The best way to test if it's your motherboard or your
  raid, is to start multiple dd processes on different disks, or
  multiple bonnie++ processes on different disks, all concurrently, of
  course.

Good luck,
Jurriaan
-- 
Never forget: 2 + 2 = 5 for extremely large values of 2.
Debian (Unstable) GNU/Linux 2.6.11-rc3-mm1 2x4734 bogomips load 0.71
