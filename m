From: "John Stoffel" <john@stoffel.org>
Subject: Re: raid1 missing disk
Date: Thu, 12 Oct 2017 17:02:12 -0400
Message-ID: <23007.55380.511790.771266@quad.stoffel.home>
References: <85523B4D-6691-44F1-A609-A5280224E352@jjd.com>
        <e3ac851f-347f-ee63-c58d-02d8a1afb4c7@thelounge.net>
        <380EE991-3AC6-43FE-87B1-A14CA2B53C7B@jjd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <380EE991-3AC6-43FE-87B1-A14CA2B53C7B@jjd.com>
Sender: linux-raid-owner@vger.kernel.org
To: James J Dempsey <jjd@jjd.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "James" == James J Dempsey <jjd@jjd.com> writes:

>> On Oct 12, 2017, at 12:48 PM, Reindl Harald <h.reindl@thelounge.net> wrote:
>>> 
>> what do you mean by "I foolishly (physically) removed the disk before software removing it from the array”?

James> I mean that I wasn’t thinking straight and the first thing I did was remove the disk and install the new disk without using mdadm to manage the array and remove the disk first.

>> if a disk explodes it also disappears unannounced

James> Yes that’s true, and this is basically the same situation.

>> "My theory of this is that the computer switched it?s idea of which disk was /dev/sda and which was /dev/sdb as a result of the original removal" does not matter at all since you need the botaloader anyways on both (grub-install) and on a RAID1 it must not matter at all which is sda and wich is sdb, both can die at any point in time and both need to be bootable at any point in time

James> Both are bootable.  What I was talking about here was when I
James> tried to resolve the problem by putting the failed disk back,
James> the raid array started up and showed me the filesystem data
James> before the raid failed the bad drive.  I.e. it was not showing
James> me the “good” “current” data presumably because it thought the
James> “failed” drive was the other one.  It was showing me the data
James> from the drive it had previously failed.

James> Thanks for your advice and thanks to Adam Goryachev for
James> suggesting I just add the new disk to the array.  I will try
James> that.

Don't forget to run upgrade-grub to make the new disk bootable as
well!  
