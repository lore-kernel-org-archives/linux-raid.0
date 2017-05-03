From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: RAID creation resync behaviors
Date: Thu, 4 May 2017 01:58:56 +0200
Message-ID: <20170503235856.GA9698@metamorpher.de>
References: <20170503202748.7r243wj5h4polt6y@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170503202748.7r243wj5h4polt6y@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, jes.sorensen@gmail.com, neilb@suse.de
List-Id: linux-raid.ids

On Wed, May 03, 2017 at 01:27:48PM -0700, Shaohua Li wrote:
> Write whole disk is very unfriendly for SSD, because it reduces lifetime.
> And if user already does a trim before creation, the unncessary write 
> could make SSD slower in the future.

I'm not a kernel developer so maybe I shouldn't reply. Feel free to ignore.

I don't see this as a big issue, whoever uses SSD will likely also fstrim, 
so all SSD will know about free blocks regardless how the drive was added 
to the RAID.

You don't resync everyday and once populated with data you just can't help 
but have many writes when adding / replacing drives. No way around it.

> An option to let mdadm trim SSD before creation sounds reasonable too.

This is my personal opinion but - there is way too much trim in Linux. 

On HDD if you did a botched mkfs on the wrong device you still had a chance 
to recover data, with SSD it's all gone in an eyeblink, because mkfs.ext4 
and other programs unfortunately do trim without asking. Lots of people 
come to this list only after already playing with mdadm --create and if 
mdadm simply started trimming SSDs too, then all would be lost.
LVM has these nice metadata backups but they're rendered useless 
if lvm.conf has issue_discards set to 1. Etc...

And it's entirely superfluous, there was a big hullabaloo when SSD were 
new, everyone was concerned about how quickly they'd die when written to, 
but tests show their endurance is considerably greater than advertized. 
A single RAID resync won't put a dent in even a consumer's SSD lifetime.

At the same time you have two utilities blkdiscard and fstrim so anyone  
who desires to trim can already easily do so with little effort. For SSD 
that return zero after TRIM you can already create like this:

blkdiscard device1
blkdiscard device2
blkdiscard device3
echo 3 > /proc/sys/vm/drop_caches # optional: Linux caches trimmed data
mdadm --create --assume-clean /dev/md ... device1 device2 device3

If you wanted mdadm to do that directly, how about a mdadm --create --trim 
which implies assume-clean? But in my opinion it should not happen unasked.
If it was up to me I'd even add a prompt asking to confirm dataloss...

As for overwrite vs. compare-write, I don't know if it's possible or 
how painful it would be to implement but could you start out comparing, 
continue while the data actually matches, but switch to presumably much 
faster overwrite mode once there are sufficient mismatches? Perhaps with a 
fallback option so it can go back to compare later if data starts to match.

So kind of a smart-compare-overwrite mode which would go something like:

Compare. Match.
Compare. Match.
Compare. Mismatch. Overwrite.
Compare. Mismatch. Overwrite x2.
Compare. Mismatch. Overwrite x4.
Compare. Match.
Compare. Mismatch. Overwrite x8.
Compare. Mismatch. Overwrite x16.

Perhaps cap the overwrite multiplier at a certain point...

Maybe a silly idea, I don't know.

Regards
Andreas Klauer
