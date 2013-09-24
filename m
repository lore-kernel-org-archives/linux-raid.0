From: Phil Turmel <philip@turmel.org>
Subject: Re: [Recovery] RAID10 hdd failureS help requested
Date: Tue, 24 Sep 2013 13:09:55 -0400
Message-ID: <5241C763.6040306@turmel.org>
References: <CAB4fJqfd1zrw_AS89ufysfyCoKNf6VYj81xov0=7y0aXoYtjxw@mail.gmail.com> <5241A06F.10704@turmel.org> <CAB4fJqezb0sWcUUgRPd4BXoWr3hNBp725gv8xnMOPmcqU8RiRw@mail.gmail.com> <5241B4B7.1010305@turmel.org> <CAB4fJqerQy7PJzK4+WSNAh7YCcHmwoAqB5vMrXeSYqzWawAS+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB4fJqerQy7PJzK4+WSNAh7YCcHmwoAqB5vMrXeSYqzWawAS+A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Karel Walters <karel.walters@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Karel,

On 09/24/2013 12:28 PM, Karel Walters wrote:
> Will find a way to do proper scrubbing and alter the timeouts on startup.
>> for x in /sys/block/sd[d-h]/device/timeout ; do echo 180 >$x ; done
> done!

Good.

>> { In the future, buy drives that wake up with ERC enabled (like your WD
>> Reds), or at least capable of enabling ERC (at every powerup). }
> Reds are on the desk next to me and will replace the raid array.

Very Good.  Mind you, the Seagates are good enough drives, they just
aren't suited to raid arrays.  Changing the driver timeouts will get you
by, but when you do encounter an error, the three minute pause will kick
many applications in the teeth.  I have a few Seagates like this kicking
around that I use for offsite backups.

>> Next, you will have to figure out which of the bumped drives belongs in
>> which slot in the array.  An old dmesg (from before the failures) or an
>> archived "mdadm --detail" would tell us that.  This is important,
>> because you *will* need to use --create --assume-clean as the drives are
>> now marked as spare--the info needed for forced assembly is gone.
> 
> This is a problem for me and maybe a harsh lesson, I added an old
> dmesg output at the end but I' m not to sure about it.

Yes, that dmesg did the trick.  The drive that failed first was #3, and
the drive the failed second was #4.  You should create a list of which
drive serial number corresponds to which raid device role, with a third
column showing the current device name.

Then we can construct an "mdadm --create --assume-clean" command that
generates the correct order.  And I would leave the partially synced
spare out entirely.

Then, to deal with the large number of pending events, you'll need to do
a "check" scrub with a very low speed limit.  To keep you from exceeding
the 10/hour read error limit in the MD kernel driver.

{ Or you can scrub at full speed until it kicks drives out, then force
assemble and restart the scrub.  Many times over in your case. }

Phil
