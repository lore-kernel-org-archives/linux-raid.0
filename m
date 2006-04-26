From: Jon Lewis <jlewis@lewis.org>
Subject: RE: Two-disk RAID5?
Date: Wed, 26 Apr 2006 15:22:38 -0400 (EDT)
Message-ID: <Pine.LNX.4.61.0604261518020.1846@soloth.lewis.org>
References: <216D6FA68B0F304DA93E95C5B786F2D12FCBBC@bart.corp.egenera.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <216D6FA68B0F304DA93E95C5B786F2D12FCBBC@bart.corp.egenera.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Jansen, Frank" <fjansen@egenera.com>
Cc: Tuomas Leikola <tuomas.leikola@gmail.com>, John Rowe <rowe@excc.ex.ac.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 26 Apr 2006, Jansen, Frank wrote:

> It is not possible to flip a bit to change a set of disks from RAID 1 to
> RAID 5, as the physical layout is different.

As Tuomas pointed out though, a 2 disk RAID5 is kind of a special case 
where all you have is data and parity which is actually also just data. 
Seems kind of like a RAID1 with extra overhead.  I don't think I've ever 
heard of a RAID5 implementation willing to handle <3 drives though.

I suspect I should have just kept out of this, and waited for someone like 
Neil to answer authoratatively.

So...Neil, what's the right answer to Tuomas's 2 disk RAID5 question? :)

----------------------------------------------------------------------
  Jon Lewis                   |  I route
  Senior Network Engineer     |  therefore you are
  Atlantic Net                |
_________ http://www.lewis.org/~jlewis/pgp for PGP public key_________
