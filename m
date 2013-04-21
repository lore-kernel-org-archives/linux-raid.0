From: Phil Turmel <philip@turmel.org>
Subject: Re: Reshape Shrink Hung Again
Date: Sun, 21 Apr 2013 13:38:01 -0400
Message-ID: <517423F9.7080203@turmel.org>
References: <96A49024-A8A7-4ED9-82B1-5AE430374EBE@bingner.com> <B3E53A19-A67B-4F55-85B8-303DCFAA7363@bingner.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <B3E53A19-A67B-4F55-85B8-303DCFAA7363@bingner.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sam Bingner <sam@bingner.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 04/21/2013 04:26 AM, Sam Bingner wrote:
> Am I doing something wrong in these emails?  I've yet to have a reply
> from anybody related to this issue... should I submit it to a
> bugtracker somewhere instead?  Do I need to provide some different
> format for my email?  Is there a specific type of goat I should
> sacrifice?

I don't think you're doing anything wrong--you just have an uncommon
problem, and the options are non-obvious.  It sounds vaguely like a
known kernel bug, but I can't call it to mind.  You are running a rather
old kernel, so the pool of people who can help with it is certainly
shrinking.

Suggestions:

1) Try a recent kernel on a livecd that supports mdadm, something like
"SystemRescueCD" (my favorite).  Allow that newer kernel to assemble
what it can.  If that gives you accessible data, you could then re-add
that failed device.  If that works, you can go back to your runtime
environment, with a now-working array, and plan a more leisurely system
upgrade.

2) Abandon the 1/2MB of unrebuilt data on the array by recreating
the array with "mdadm --create --assume-clean", using "missing" in place
of sda2.  You have good dumps of your metadata, so that is relatively
low-risk.  (Do verify that the chunk and data offset of the
newly-created array match the originals before you allow anything to
write to the array!  "fsck -n" is your friend.)  Then you can add sda2
and let it rebuild.

Given that I've never had this problem, I'm not 100% confident in this
advice.  You might want to wait a bit for folk with more 2.6.32
experience to pipe up.

Phil
