From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: Re: Recommendations for RAID setup needed
Date: Mon, 21 Sep 2015 23:16:26 -0500
Message-ID: <5600D61A.6000908@suddenlinkmail.com>
References: <CAB1R3sjKb-aXJV+4E5t6OsWid4QB+r6aCteZt+F+57=cWLhHWw@mail.gmail.com> <55F85E9F.1070100@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55F85E9F.1070100@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9/15/2015 1:08 PM, Wols Lists wrote:
> Throwing something completely different into the mix, how about
> considering btrfs? It's not 100% solid yet, so you need to be careful
> with it, but if you back up with rsync and the "in place" option, it'll
> give you full backups for the cost of incremental.
>
> What you MUST do is KEEP AN EYE ON DISK SPACE! The main failure mode for
> btrfs I'm aware of, is that a disk full can cause a fatal error. As in
> "I've just trashed the disk - it's 'format c:' time". So if you hit 80%
> or so, alarm bells should be ringing. Very loud.

This is the exact reason NOT to use btrfs at the moment. The issue is 
with the 'snap shotting' feature which can quietly fill your disk with 
snap shots to the point of space exhaustion that has resulted in the 
complete loss of information in a number of instances.

Why would you recommend a filesystem when "It's not 100% solid yet" to 
someone looking for enhanced data integrity?

Your warning is well taken, and while btrfs is getting better all the 
time, for a raid install where the object is to eliminate (or greatly 
lessen) the chance of data loss, stick with a tried and true filesystem 
unless you want to become an unwitting beta-tester with your data on the 
line...

-- 
David C. Rankin, J.D.,P.E.
