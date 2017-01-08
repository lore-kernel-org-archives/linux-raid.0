From: Benjammin2068 <benjammin2068@gmail.com>
Subject: Re: Recommendation on new system Arrays
Date: Sat, 7 Jan 2017 22:04:25 -0600
Message-ID: <6017e35e-6328-bf8b-fb25-eb8afbf163ba@gmail.com>
References: <4259f5ef-42f7-ad4c-c8af-7b6e5c19354c@gmail.com>
 <5870BD30.3020302@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5870BD30.3020302@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On 01/07/2017 04:04 AM, Wols Lists wrote:
> On 06/01/17 16:14, Benjammin2068 wrote:
>>     * the other as a data drive for use with surveillance software (from Milestone probably) running in a VM as a secondary storage vault for company cameras/NVRs that are remote. (like a backup system)
> If you were planning on a raid-6, how about a mirror for this drive? I
> believe it is not a good choice for a general raid, but if you're only
> writing *NEW* stuff for the most part, and streaming big files to disk,
> how about these new WD shingled disks (Purples, I believe).
>
> This sounds like one of the few use cases where they might be a good
> idea. Worth considering, at least. Might even work well in your planned
> raid-6 config.
>

Yea, I thought about that too. So you're suggesting a RAID1 consisting of (2) RAID6 arrays.

Will mdadm do that?

Also in other news.... (maybe someone from this list can help since they've run into it before)

The motherboard of the computer has its own SATA controller as usual... as well as this Avago SAS controller.

When CentOS 7 boots up, it enumerates the external SAS drives starting at /dev/sda instead of the motherboard's drives.

The OCD in me wants the MB's SATA drives as /dev/sda-sdd.

Where does one even control that enumeration order? udev? Eeks.

(I'm not finding a query that google makes sense out of to give me a decent set of suggested links.)

 -Ben
