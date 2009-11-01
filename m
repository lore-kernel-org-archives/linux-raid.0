From: "NeilBrown" <neilb@suse.de>
Subject: Re: unbelievably bad performance: 2.6.27.37 and raid6
Date: Mon, 2 Nov 2009 10:43:49 +1100
Message-ID: <da6356c80d046663baad24dd41b6e989.squirrel@neil.brown.name>
References: <cccedfc60910310855l5ca6c42aj503fb0e4fd6232ad@mail.gmail.com>
    <200910311243.35126.tfjellstrom@shaw.ca> <4AEDE38F.3080408@gmail.com>
    <200911011241.40735.tfjellstrom@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200911011241.40735.tfjellstrom@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: tfjellstrom@shaw.ca
Cc: Andrew Dunn <andrew.g.dunn@gmail.com>, Jon Nelson <jnelson-linux-raid@jamponi.net>, LinuxRaid <linux-raid@vger.kernel.org>, pernegger@gmail.com
List-Id: linux-raid.ids

On Mon, November 2, 2009 6:41 am, Thomas Fjellstrom wrote:
> On Sun November 1 2009, Andrew Dunn wrote:
>> Are we to expect some resolution in newer kernels?
>
> I assume all of the new per-bdi-writeback work going on in .33+ will have
> a
> large impact. At least I'm hoping.
>
>> I am going to rebuild my array (backup data and re-create) to modify the
>> chunk size this week. I hope to get a much higher performance when
>> increasing from 64k chunk size to 1024k.
>>
>> Is there a way to modify chunk size in place or does the array need to
>> be re-created?
>
> This I'm not sure about. I'd like to be able to reshape to a new chunk
> size
> for testing.

Reshaping to a new chunksize is possible with the latest mdadm and kernel,
but I would recommend waiting for mdadm-3.1.1 and 2.6.32.
With the current code, a device failure during reshape followed by an
unclean shutdown while reshape is happening can lead to unrecoverable
data loss.  Even a clean shutdown before the shape finishes in that case
might be a problem.

NeilBrown

