From: Neil Brown <neilb@suse.de>
Subject: Re: deleting mdadm array?
Date: Thu, 25 Oct 2007 20:12:02 +1000
Message-ID: <18208.27634.262419.581091@notabene.brown>
References: <20071025100619.3b3810be@absurd>
	<47206820.4020005@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David Greaves on Thursday October 25
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Janek Kozicki <janek_listy@wp.pl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday October 25, david@dgreaves.com wrote:
> I think the only time you need to 'delete' an array before creating a new one is
> if you change the superblock version since it quietly writes different
> superblocks to different disk locations you may end up with 2 superblocks on the
> disk and then you get confusion :)
> (I'm not sure if mdadm is clever about this though...)
> 

Mdadm tries to be clever.

When creating an array, it zeros any superblocks that it finds on the
array in any of the expected locations.
And when guessing the metadata format used, if it find two or more, it
chooses the one with the more recent create timestamp.

NeilBrown
