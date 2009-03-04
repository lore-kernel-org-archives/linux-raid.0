From: Big Wave Dave <bigwavedave@gmail.com>
Subject: Re: Question on Raid 5 array initial creation times
Date: Tue, 3 Mar 2009 23:56:33 -0800
Message-ID: <8e124f160903032356k6346c370n1974fb95c53e5f7f@mail.gmail.com>
References: <3513de790903032058o231d9083n20092b78ed241d3b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3513de790903032058o231d9083n20092b78ed241d3b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dylan Distasio <interzone@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Mar 3, 2009 at 8:58 PM, Dylan Distasio <interzone@gmail.com> wrote:
> I wanted to check to see if anyone could provide a rough estimate of
> how long a RAID 5 initial build should take under mdadm.
>
> I am creating a RAID 5 array with 5x1TB Western Digital Black 7200RPM
> SATA drives on the following system:
>
> Ubuntu 8.10 / ext3 filesystem on array and OS drive
> 1 gig of PC3200 RAM
> AMD Athlon 64 3200+
> Nforce4 motherboard
>
> I am getting a minimum speed of approximately 14000K/sec with an
> estimated finish time of roughly 19 hrs from now.
>
> Is this a reasonable speed for creating a RAID 5 array with mdadm?
>
> Thanks.

I actually did a similar setup recently, and it was very similar
timing.  I'm not sure if it should have been faster/slower, but I can
confirm I saw the same thing.

Dave
