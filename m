From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: mdadm raid1 read performance
Date: Wed, 04 May 2011 01:57:28 +0100
Message-ID: <4DC0A478.9010704@anonymous.org.uk>
References: <BANLkTim8Ehn0fANtibg7X1cMVvOgt7CNMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTim8Ehn0fANtibg7X1cMVvOgt7CNMA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Liam Kurmos <quantum.leaf@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 04/05/2011 01:07, Liam Kurmos wrote:
> Hi,
>
> I've been testing mdadm (great piece of software btw) however all my
> test show that reading from raid1 is only the same speed as reading
> from a single drive.
>
> Is this a known issue? or is there something seriously wrong with my
> system? i have tried v2.8.1 and v.3.2.1 without difference and several
> benchmarking methods.

This is a FAQ. Yes, this is known. No, it's not an issue, it's by design 
- pretty much any RAID 1 implementation will be the same because of the 
nature of spinning discs. md RAID 1 will serve multiple simultaneous 
reads from the different mirrors, giving a higher total throughput, but 
a single-threaded read will read from only one. If you want RAID 0 
sequential speed at the same time as RAID 1 mirroring, look at md RAID 
10, and in particular RAID 10,f2; please see the excellent documentation 
and wiki for more details.

Cheers,

John.

