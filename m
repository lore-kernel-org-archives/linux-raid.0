From: starlight.2012q4@binnacle.cx
Subject: Re: question: no-bitmap RAID1 with off-site drive
Date: Mon, 26 Nov 2012 22:31:45 -0500
Message-ID: <6.2.5.6.2.20121126222430.06485a08@binnacle.cx>
References: <6.2.5.6.2.20121111163935.05df8b18@binnacle.cx>
 <6.2.5.6.2.20121112122534.05dfec78@binnacle.cx>
 <6.2.5.6.2.20121118185613.05e63580@binnacle.cx>
 <20121127133155.2132a857@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121127133155.2132a857@notabene.brown>
References: <6.2.5.6.2.20121111163935.05df8b18@binnacle.cx>
 <6.2.5.6.2.20121112122534.05dfec78@binnacle.cx>
 <6.2.5.6.2.20121118185613.05e63580@binnacle.cx>
 <20121127133155.2132a857@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

At 01:31 PM 11/27/2012 +1100, NeilBrown wrote:
>> 
>> Appears then that 'mdadm' may not
>> check the superblock to see if the
>> drive came from a different array
>> and should not be overwritten, and
>> instead prefers to just zap it.
>
>Correct.  When you ask mdadm to --add device to
>an array, that is what it will do.  If the
>metadata looks particularly good it might do a 
>re-add for you, but if not it will just erase
>it and write some more.

Thank you very much for the confirmation.

>> Can anyone confirm or deny the
>> possibility?  I can manually run
>> an --examine and check the array
>> name as a precaution when rotating
>> drives if 'mdadm' doesn't perform
>> the check.  Want to avoid inserting
>> a offsite drive in the wrong array.
>
>We might be able to make "mdadm -I" do what
>you want ... find out which array
>it "should" be a member of and auto-add it.
>But that will currently fail for an
>out-of-date member with no bitmap.
>

Actually I was thinking more about 'mdadm'
not destroying an old-but-good mirror
copy from a different array.  So if I
accidently pull the wrong drive out of
the safe deposit box, then 'mdadm' would
refuse to zap and re-label the drive on
an attempt to insert it in the wrong
array.  An explicit --zero-superblock
would have to be run before a drive could
be re-used in any array with a different
name.

Not a big deal though.  I will be sure
to --examine all rotate-in drives
carefully before --grow --add'ing them.

