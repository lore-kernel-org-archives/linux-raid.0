From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: mount(2) system call failed: Structure needs cleaning?
Date: Fri, 27 Oct 2017 10:45:09 +0100
Message-ID: <59F30025.5020803@youngman.org.uk>
References: <021c3df6-536c-73bc-84e2-281d4bd8099d@suddenlinkmail.com>
 <5a939404-9405-1721-99c9-0884dc978702@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5a939404-9405-1721-99c9-0884dc978702@suddenlinkmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David C. Rankin" <drankinatty@suddenlinkmail.com>, mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 27/10/17 01:59, David C. Rankin wrote:
> Yes, it looks like something on the array was corrupted. When I attempt to set
> the --size to the exact size of the array, it says I have 4 less bytes than
> the original array size:
> 
> # mdadm --verbose --create /dev/md126 --level=1 --raid-devices=2
> --metadata=1.0 --bitmap=internal --size=20972752 --readonly
> --uuid=e45cfbeb:77c2b93b:43d3d214:390d0f25 /dev/sdf5 missing
> mdadm: /dev/sdf5 is smaller than given size. 20972748K < 20972752K + metadata
> mdadm: create aborted
> 
> (this is an old ATA drive, so I wonder if the 4096 block size is messing
> things up?)
> 
> Is there a way out of this conundrum?

Quite likely, but there's a good chance you'll need a disk hex editor :-(

You say you ran "mdadm --create" over the array? Oh dear oh dear oh
dear! :-(

If the array was originally 1.0, and the re-create created it as 1.2, it
just stomped all over your data.

And now it's probably having problems re-assembling because it's finding
two superblocks and doesn't know what to do with them.

Bottom line, yes I suspect your array is recoverable. But your
filesystem is ALSO damaged, and trying to fix two problems has probably
squared the workload ... :-(

The only good news I can see is it's a mirror. Your best bet is probably
to destroy both superblocks, and try and mount the partition directly
not as a mirror. That way, your only problem will be a damaged
filesystem. Don't try this until you've had better advice than mine, though!

Cheers,
Wol (the bringer of bad news :-(
