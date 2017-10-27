From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: mount(2) system call failed: Structure needs cleaning?
Date: Fri, 27 Oct 2017 11:25:05 +0100
Message-ID: <59F30981.1050205@youngman.org.uk>
References: <021c3df6-536c-73bc-84e2-281d4bd8099d@suddenlinkmail.com>
 <5a939404-9405-1721-99c9-0884dc978702@suddenlinkmail.com>
 <59F30025.5020803@youngman.org.uk>
 <3f1359a2-f07a-f75e-605a-0d271df11913@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3f1359a2-f07a-f75e-605a-0d271df11913@suddenlinkmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David C. Rankin" <drankinatty@suddenlinkmail.com>, mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 27/10/17 11:02, David C. Rankin wrote:
> How best to clear this array completely so that it doesn't cause mdadm any
> problem on the rebuild from the good array?

My favourite ... "dd if=/dev/zero of=/dev/sdX". Takes a
LLoooonnnnnngggggggg time.

But there is an option to mdadm that will wipe the superblock. I don't
know whether it will wipe both at once, I'd try it three times and if it
comes back with "can't find superblock" the third time you know it's
done :-) I've never used it so I can't say how it works.

Oh - and when you add it back to the good disk, use --add, and NOT
--re-add. That implies to mdadm that it's a new disk needing re-config.

Cheers,
Wol
