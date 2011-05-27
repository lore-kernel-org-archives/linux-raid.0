From: NeilBrown <neilb@suse.de>
Subject: Re: Upgrading from metadata 0.9
Date: Sat, 28 May 2011 07:38:53 +1000
Message-ID: <20110528073853.2b9ead34@notabene.brown>
References: <4DDEA8AB.4090709@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DDEA8AB.4090709@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 26 May 2011 15:23:23 -0400 Phillip Susi <psusi@cfl.rr.com> wrote:

> Is there a way to upgrade an existing raid array using metadata format 
> 0.9 to a 1.x format without loosing data?

Not really.  It is on my list of nice-to-have features for mdadm, but it is
not near the top.

As 1.x uses less space for metadata you could simply recreate the array as
  --metadata=1.0
All the data would still be there.
You should be as explicit as possible in the --create command.

mdadm --create /dev/md0 --level=XX --raid-disks=YY --chunk=ZZ --size=QQ
   --layout=LL  --assume-clean --metadata=1.0

You can only convert to 1.0 metadata as 1.1 and 1.2 put the metadata  on top
of where data currently is.


NeilBrown

