From: Phil Turmel <philip@turmel.org>
Subject: Re: mismatch sector in range, kernel 4.13
Date: Sat, 9 Sep 2017 14:25:33 -0400
Message-ID: <bd2a9b4d-c450-0bae-602d-870b9f0c326c@turmel.org>
References: <20170909174230.fs5a5yhf66mucnlq@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170909174230.fs5a5yhf66mucnlq@merlins.org>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>, Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/09/2017 01:42 PM, Marc MERLIN wrote:
> Howdy,
> 
> Thanks both for the answer.
> 
> On Mon, Sep 04, 2017 at 11:49:44PM -0400, Phil Turmel wrote:
>>> Given this, what is the suggested course of action?
>>
>> Do a "repair" scrub (once) instead of a check scrub to fix the parity.
>> The data blocks themselves (the ones you care about) must be OK since
>> btrfs is happy.
>>
>> If future check scrubs keep running into this, investigate if the ranges
>> reported are all falling on a particular disk, and look for hardware issues.
> 
> On Tue, Sep 05, 2017 at 08:25:58AM +0200, Mikael Abrahamsson wrote:
>> If the data section is fine (which it seems to be because btrfs is happy),
>> then you should issue "repair" to correct parity.
>>
>> "echo repair > /sys/block/mdX/md/sync_action"
> 
> So you're both saying the same thing on how to fix it, but do we agree
> that somehow it's my parity data that went wrong since the filesystem
> seems fine?

Yes.  Sort of.  Btrfs fixed anything that went wrong on data blocks and
can't see anything wrong on parity blocks.  So only parity errors will
matter in any stripes used by btrfs.

> Do we also agree that "mistmatch sector" means that the parity does not
> add up, and that in a raid5 scenario, the md layer has no idea which of
> the drives has bad data, just that things don't add up?

mismatch does mean that parity doesn't add up.  But don't presume that
raid6 can figure out which, as there are many possibilities outside of
reconstruction math.  (See all prior flamewars on this topic and look at
the raid6check utility program.)

Phil
