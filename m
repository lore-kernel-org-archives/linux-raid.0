From: Phil Turmel <philip@turmel.org>
Subject: Re: mdadm stuck at 0% reshape after grow
Date: Wed, 6 Dec 2017 09:15:21 -0500
Message-ID: <61c9e4bd-1605-5b17-80ce-c738b80b7058@turmel.org>
References: <CAGx2nv6cZ85YCrUQsCBWfojFxOyqW4=+5OaCqU1Gf0UX=T3Gbg@mail.gmail.com>
 <1865221512489329@web5g.yandex.ru>
 <d34ebd38-47e5-35bc-5ee6-0da194ce1901@turmel.org>
 <CAGx2nv6YAc5jBL36K0oNG=tE5J3TNXGMvTvD9ZvcZYthXe9Y5g@mail.gmail.com>
 <20171206104905.GA4383@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20171206104905.GA4383@metamorpher.de>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>, Jeremy Graham <jeremy@doghouse.agency>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/06/2017 05:49 AM, Andreas Klauer wrote:
> On Wed, Dec 06, 2017 at 03:33:36PM +1100, Jeremy Graham wrote:
>> How do I "manually regenerate content for each block in BBL's and then
>> manually zero the lists in superblocks"? This is uncharted (and
>> slightly scary) territory for me.
> 
> You don't. Just mdadm --assemble it with --update=force-no-bbl here.

The problem with this is that the sectors currently marked don't have
appropriate data.  So garbage will be read in those locations after the
BBL is deleted.

There's only two approaches with any hope of rescuing the content:

1) Backup everything that is known to involve the BBL sectors, then
restore those files after the BBL is deleted.

2) Use hdparm to fake bad sectors on the underlying device in the same
locations as the BBL.  Then run a scrub after the BBL is deleted.  A bit
risky, as MD only allows 10 UREs per hour before kicking a drive.  The
array might need --assemble --force multiple times to complete the scrub.

> If you have a filesystem with bad blocks management on top of it, 
> check that too and clear it if necessary.

MD's BBL system doesn't coordinate with the filesystem on top, so this
is meaningless.

The BBL in MD is woefully incomplete and should *never* be used.

Phil
