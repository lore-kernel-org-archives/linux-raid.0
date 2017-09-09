From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: mismatch sector in range, kernel 4.13
Date: Sat, 9 Sep 2017 19:26:51 +0100
Message-ID: <e48c2cae-dd3a-f854-0030-8e2892fa183d@youngman.org.uk>
References: <20170909174230.fs5a5yhf66mucnlq@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170909174230.fs5a5yhf66mucnlq@merlins.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/09/17 18:42, Marc MERLIN wrote:
> Do we also agree that "mistmatch sector" means that the parity does not
> add up, and that in a raid5 scenario, the md layer has no idea which of
> the drives has bad data, just that things don't add up?

Yes. Raid 5 only protects you from a disk failure. With one parity 
block, you can only solve the equation for one unknown, ie for a missing 
block (drive). If a block is corrupt, that gives you two unknowns - 
which block is corrupt and what the correct value should be. With raid-6 
you have two parity blocks so can solve for two unknowns ie one random 
corrupt block OR two drive failures.

But with raid 5 you can only solve for a missing/corrupt block IF you 
can tell the system which one is messed up. Btrfs is telling you that 
the data is fine, so you know it's the parity, and raid 5 can fix that 
for you.

Cheers,
Wol
