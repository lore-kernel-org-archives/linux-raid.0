From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: md.txt, preread_bypass_threshold and raid5: corrected error
Date: Sat, 15 Nov 2008 15:52:06 -0700
Message-ID: <e9c3a7c20811151452p4ba18eaai89962572579c0891@mail.gmail.com>
References: <alpine.DEB.1.10.0811121144250.12675@p34.internal.lan>
	 <e9c3a7c20811141700v736d7a3ep4362a96fc5afe90b@mail.gmail.com>
	 <491F0C44.9070403@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <491F0C44.9070403@sauce.co.nz>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Nov 15, 2008 at 10:52 AM, Richard Scobie <richard@sauce.co.nz> wrote:
> Dan Williams wrote:
>
>> By default MD tries to be fair and allow partially written stripes the
>> same access to the disk as fully written stripes to prevent starvation
>> for little writers.  However, you can sometimes eek out more streaming
>> performance at the cost of fairness by increasing this value (where 0
>> == never let a preread pass a full-stripe-write).
>
> I believe XFS optimises for full stripe writes, so perhaps this setting is
> of more benefit for other file systems?
>

Not really.  XFS was used when benchmarking this change [1] and was
able to measure a performance gain.

[1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8b3e6cdc53b7f29f7026955d6cb6902a49322a15
