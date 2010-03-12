From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Resize RAID-0?
Date: Fri, 12 Mar 2010 10:40:58 +0000
Message-ID: <4B9A1A3A.6000209@anonymous.org.uk>
References: <23986fd91003111939w102813c6r8d1b51a387784a71@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <23986fd91003111939w102813c6r8d1b51a387784a71@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Patrick J. LoPresti" <lopresti@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/03/2010 03:39, Patrick J. LoPresti wrote:
> From reading the documentation and source code, I gather "mdadm
> --grow" is not supported for RAID-0 devices.
> 
> In my application, I am using md RAID-0 to stripe among several
> (identical) hardware RAID-0 chassis.  I would like to extend my setup
> by adding another chassis, but apparently, I cannot (?).

If I remember correctly, there were patches posted to this list recently 
to add support for reshaping RAID-0, and for migrating from RAID-0 to 
other RAID levels, but I don't remember whether they've made it in to 
the kernel/mdadm yet. I recommend a trawl through the last few months' 
archives.

Cheers,

John.
