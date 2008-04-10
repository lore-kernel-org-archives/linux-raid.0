From: rosenfield.albert@gmail.com
Subject: two questions re. proactive recovery and forced assembly
Date: Thu, 10 Apr 2008 14:01:31 +0200
Message-ID: <c4985c940804100501g5cac252ax129328371c36d397@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Howdy

I couldn't find these in the archives, so here goes.

Background:
I have a broken MD RAID5 array. A disk had a sector failure, and
shortly thereafter another had a failure in an unrelated sector.  The
current situation is that MD will not assemble the array.  Since
everything's broken anyway, and I'll be spending a lot of time in this
direction, I'm going to upgrade the entire system with new software
and maybe new disks.

Question 1.
In order to get to my data, is it still the old clunky procedure of
creating a new array on top of the old one, and crossing your fingers
hoping that the superblocks land in the right places and nothing gets
reinitialized?

Or has mdadm at this point grown a feature to forcibly assemble an
array with two kicked devices?

Question 2.
A background scan feature has been discussed a few times, my English
is limited but I find this explanation to be a good one:
http://thread.gmane.org/gmane.linux.raid/2206

According to a wishlist found here:
http://arctic.org/~dean/raid-wishlist.html, Neil Brown has been
gratuitous enough to spend time implementing said feature.  Reading
the details though, it seems like we only have error correction when
MD accidentally stumbles on a failed sector.

At first I thought I could add a cron job a la "dd if=/dev/mdX of=- |
throttle -M1 >/dev/null" to scan the entire MD array, but this would
be no better - a good RAID implementation such as MD would of course
load balance and read from all disks in a RAID1 at the same time, so
for a two-disk array that means that this command will only catch half
of all the sector errors that pop up.  Probabilities worsen for arrays
containing more devices, of course.

Does a proper solution for this exist in MD yet?

(If not, I'll probably buy hardware RAID instead, recently having had
good experience with resizing a pretty weird array using the CLI for
the SmartArray line of controllers.)
