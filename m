From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: using dd (or dd_rescue) to salvage array
Date: Fri, 03 Feb 2012 08:08:00 -0800
Message-ID: <0cdtv8xv8f.ln2@goaway.wombat.san-francisco.ca.us>
References: <8eekv8xpcn.ln2@goaway.wombat.san-francisco.ca.us>
 <kesmv8xc66.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2012-02-01, Keith Keller <kkeller@wombat.san-francisco.ca.us> wrote:
>
> Well, for better or worse, this is now a moot question--I had another
> drive kicked out of the array, I believe prematurely by the controller.

It turns out to be worse--the drive does in fact appear to be failing,
which would be the third failure on this RAID6 array.  I had what might
be a crazy thought--would it be worth the trouble to attempt to use dd
(or dd_rescue, a tool I found that claims to continue on bad blocks) to
write the disk image to another disk, and attempt a rebuild with the new
disk?  Or am I just wasting my time?  (The array is hosting an rsnapshot
backup set, so I can recreate the latest snapshot, but it'll take a
while.  So it'd be nice to save the array if it's possible and not time-
consuming.)

Thanks for your help!

--keith

-- 
kkeller@wombat.san-francisco.ca.us


