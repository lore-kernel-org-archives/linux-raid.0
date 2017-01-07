From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Recommendation on new system Arrays
Date: Sat, 7 Jan 2017 10:04:32 +0000
Message-ID: <5870BD30.3020302@youngman.org.uk>
References: <4259f5ef-42f7-ad4c-c8af-7b6e5c19354c@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4259f5ef-42f7-ad4c-c8af-7b6e5c19354c@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Benjammin2068 <benjammin2068@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/01/17 16:14, Benjammin2068 wrote:
>     * the other as a data drive for use with surveillance software (from Milestone probably) running in a VM as a secondary storage vault for company cameras/NVRs that are remote. (like a backup system)

If you were planning on a raid-6, how about a mirror for this drive? I
believe it is not a good choice for a general raid, but if you're only
writing *NEW* stuff for the most part, and streaming big files to disk,
how about these new WD shingled disks (Purples, I believe).

This sounds like one of the few use cases where they might be a good
idea. Worth considering, at least. Might even work well in your planned
raid-6 config.

Cheers,
Wol
