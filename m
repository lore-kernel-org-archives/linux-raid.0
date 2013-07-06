From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: question about the best suited RAID level/layout
Date: Sat, 06 Jul 2013 13:29:08 +0800
Message-ID: <51D7AB24.1030003@fnarfbargle.com>
References: <1372961877.8716.43.camel@heisenberg.scientia.net>  <51D5EC8A.40509@turmel.org> <1372978687.5249.52.camel@fermat.scientia.net>  <51D61C58.2020207@fnarfbargle.com> <1373070976.5395.26.camel@fermat.scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1373070976.5395.26.camel@fermat.scientia.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/07/13 08:36, Christoph Anton Mitterer wrote:
> Hi Brad.
>

> And when we remember back at the issues (IIRC) Seagate had with the
> firmwares of some of it's devices, that suddenly stopped working at some
> special date...

I had 10 of those in a RAID-6 at the time. Luckily the firmware bug only 
manifested itself on a re-start of the drive, and as I probably drop 
power to the machine once a year (if that), I could drop them out of the 
array one at a time, upgrade the firmware and re-add it to the array.

A messy process to be sure, but no risk of data loss that way.


