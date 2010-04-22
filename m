From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Use of WD20EARS with MDADM
Date: Thu, 22 Apr 2010 16:23:22 -0700
Message-ID: <z2y5bdc1c8b1004221623l3d83165ek3e605d74132a2de3@mail.gmail.com>
References: <4BAB8D41.4010801@gmail.com>
	 <y2x5bdc1c8b1004211036ra8e10a43kc1a13c2b374a5f7b@mail.gmail.com>
	 <4BCF4693.3020101@buttersideup.com>
	 <201004221913.50692.eye.of.the.8eholder@gmail.com>
	 <4BD0A716.4080909@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BD0A716.4080909@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Khelben Blackstaff <eye.of.the.8eholder@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Apr 22, 2010 at 12:44 PM, Phillip Susi <psusi@cfl.rr.com> wrote:
> On 4/22/2010 12:13 PM, Khelben Blackstaff wrote:
>> WD mentions in the customer help (Answer ID 5357) that these newer drives
>> were validated to 1M load/unload cycles and not 300K.
>
> Weird, I wonder if they just forgot to update the spec sheet for the
> drive then since it says 300k.

Validated doesn't mean spec'ed, right? So they spec it at 300K but
they test and find that some units go to 1M, so they report that some
units go to 1M but they keep the spec at 300K. We feel more
comfortable with the operation but if the drive fails at 400K then
they are within their rights to say the drive lived a useful life and
replace or not replace it as they see fit.

I have 7 of these WD10EARS green drives, one in the machine I reported
on that's 350 miles away, but 6 sitting in boxes here. I think I'll
look into using the WD program to modify one or two of them and then
start some testing.

Keep in mind that just because we possibly solve the load cycle count
problem doesn't mean that the drive will work for RAID. WD has also
stated that these drives don't have any TLER features.

I'll report back how that goes, but I don't know exactly when.

Cheers,
Mark
