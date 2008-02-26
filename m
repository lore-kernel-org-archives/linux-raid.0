From: Philip Molter <philip@datafoundry.com>
Subject: Re: raid1 error handling and faulty drives
Date: Tue, 26 Feb 2008 10:23:57 -0600
Message-ID: <47C43D1D.3020103@datafoundry.com>
References: <915.1189030947@mdt.ecitele.com> <18143.36574.398690.36732@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18143.36574.398690.36732@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> I've recently become aware that we really need FAILFAST - possibly for
> all IO from RAID1/5.  Modern drives don't need any retry at the OS
> level - if the retry in the firmware cannot get the data, nothing will.
 >
> Thanks.  I agree that we do need something along these lines.  It
> might be a while before I can give the patch the brainspace it
> deserves as I am travelling this fortnight.
> 
> NeilBrown

Neil,

Was anything ever done with this idea?  I can throw my hat into the 
this-is-a-big-problem ring.  I oftentimes have a RAID1 disk fail on a 
heavy-I/O system and the system basically needs to be power-cycled if it 
is to come back up within the hour (any OS access to that RAID will hang).

Any word would be appreciated.

Philip
