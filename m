From: "Ravi (Tom) Hale" <ravi@hale.ee>
Subject: Re: Fault tolerance with badblocks
Date: Sat, 6 May 2017 18:21:53 +0700
Message-ID: <bd917050-cf73-6922-bb20-c5ccf02ba51c@hale.ee>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee>
 <590B3039.3060000@youngman.org.uk>
 <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee>
 <d2b25ec0-c401-07df-2231-a37117878589@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d2b25ec0-c401-07df-2231-a37117878589@youngman.org.uk>
Content-Language: en-AU
Sender: linux-raid-owner@vger.kernel.org
To: Anthony Youngman <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/05/17 02:20, Anthony Youngman wrote:
> Bear in mind I'm speculating slightly here ... but how are you going to
> know when the drive has run out of its spare-pool? Bear in mind that
> most SSDs, it seems, will commit suicide at this point ...

Intel and Samsung SSDs support S.M.A.R.T. (but not my personal laptop).

> Bear in mind also, that any *within* *spec* drive can have an "accident"
> every 10TB and still be considered perfectly okay. Which means that if
> you do what you are supposed to do (rewrite the block) you're risking
> the drive remapping the block - and getting closer to the drive bricking
> itself. But if you trap the error yourself and add it to the badblocks
> list, you are risking throwing away perfectly decent blocks that just
> hiccuped.

For hiccups, having a bad-read-count for each suspected-bad block could
be sensible. If that number goes above <small-threshold> it's very
likely that the block is indeed bad and should be avoided in future.

-- 
Tom Hale
