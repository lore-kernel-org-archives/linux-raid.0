From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Performance Characteristics of All Linux RAIDs
 (mdadm/bonnie++)
Date: Wed, 28 May 2008 16:01:22 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0805281600400.30866@p34.internal.lan>
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan> <483D7CE8.4000600@redhat.com> <483DBA96.4010105@sauce.co.nz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <483DBA96.4010105@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: Chris Snook <csnook@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Thu, 29 May 2008, Richard Scobie wrote:

> Chris Snook wrote:
>
>> course, you'd want to use a single SATA controller with a known good NCQ 
>> implementation, and hard drives known to not do stupid things like disable 
>> readahead when NCQ is enabled.
>
> Do you have a list of drives that do disable readahead on NCQ?
The WD Raptor 150s performance is horrible w/NCQ enabled and I believe 
someone spoke of this before on the mailing list... (but in Windows it is 
OK/not affected)?

>
> Regards,
>
> Richard
>
