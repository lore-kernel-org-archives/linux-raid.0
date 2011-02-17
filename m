From: NeilBrown <neilb@suse.de>
Subject: Re: Shouldn't --zero-superblock reset the UUID?
Date: Thu, 17 Feb 2011 12:45:16 +1100
Message-ID: <20110217124516.59c226e4@notabene.brown>
References: <AANLkTikuHrSyhmi01LgKGZhMCvAKoXJmutwhfL974zvT@mail.gmail.com>
	<4D5C7801.5070306@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5C7801.5070306@fastmail.fm>
Sender: linux-raid-owner@vger.kernel.org
To: linbloke <linbloke@fastmail.fm>
Cc: hansbkk@gmail.com, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 17 Feb 2011 12:21:05 +1100 linbloke <linbloke@fastmail.fm> wrote:

> hansbkk@gmail.com wrote:
> > I've only seen this problem with RAID1, but perhaps it applies to other levels.
> >
> > When adding a member partition to an array, the UUID of that partition
> > gets set to that of the array (and all the other members)
> >
> > However, when fail/remove/zero-superblock 'ing a member back out of
> > the array, the UUID gets left behind, along with the label and fs
> > type.
> >
> > Ideally the partition would be left in a state as if it never had any
> > filesystem at all on it, as when using dd /if=dev/zero and a fresh
> > sfdisk.
> >
> > If this isn't possible, perhaps the zero-superblock option should
> > trigger a reminder message to either zero the drive or re-format the
> > partition?
> >
> >   
> I recall reading on this list that zero-superblock only zero's the first 
> superblock that it finds. It may be necessary to run mdadm 
> zero-superblock several times to remove all superblocks that may be on 
> the device from historical times.
> 

The latest mdadm will zero all superblocks it can find.

How I suspec the OP is actually talking about a 'filesystem' uuid rather than
a 'raid' uuid...  After all it is "along with the label and fs type".

So: kansbkk: What makes you think the uuid is left behind?  Knowing that will
  help know what uuid you are talking about.

NeilBrown

