From: Phil Turmel <philip@turmel.org>
Subject: Re: Buffer I/O error on dev md5, logical block 7073536, async page
 read
Date: Sun, 30 Oct 2016 12:34:56 -0400
Message-ID: <f6b83548-cb8b-be21-ee4f-cae9f7fa2950@turmel.org>
References: <20161030021614.asws67j34ji64qle@merlins.org>
 <20161030093337.GA3627@metamorpher.de> <20161030153857.GB28648@merlins.org>
 <20161030161929.GA5582@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161030161929.GA5582@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>, Marc MERLIN <marc@merlins.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/30/2016 12:19 PM, Andreas Klauer wrote:
> On Sun, Oct 30, 2016 at 08:38:57AM -0700, Marc MERLIN wrote:
>> (mmmh, but even so, rebuilding the spare should have cleared the bad blocks
>> on at least one drive, no?)
> 
> If n+1 disks have bad blocks there's no data to sync over, so they just 
> propagate and stay bad forever. Or at least that's how it seemed to work 
> last time I tried it. I'm not familiar with bad blocks. I just turn it off.

I, too, turn it off.  (I never let it turn on, actually.)

I'm a little disturbed that this feature has become the default on new
arrays.  This feature was introduced specifically to support underlying
storage technologies that cannot perform their own bad block management.
 And since it doesn't implement any relocation algorithm for blocks
marked bad, it simply gives up any redundancy for affected sectors.  And
when there's no remaining redundancy, it simply passes the error up the
stack.  In this case, your errors were created by known communications
weaknesses that should always be recoverable with --assemble --force.

As far as I'm concerned, the bad block system is an incomplete feature
that should never be used in production, and certainly not on top of any
storage technology that implements error detection, correction, and
relocation.  Like, every modern SATA and SAS drive.

Phil
