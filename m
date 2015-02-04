From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: Off-Topic Write cache disabling?
Date: Wed, 04 Feb 2015 13:45:33 +0100
Message-ID: <54D2146D.8020108@fastmail.fm>
References: <CAFE24U1G9+bqTzK4eD-cenyc5CGQQdrcu7S9Ks4CsHPS9wJ4zA@mail.gmail.com> <CAAMCDedvF+Nv9LYqM7Ddgg2xMQKtgQDntOsG0krxWCV4H+zQmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAMCDedvF+Nv9LYqM7Ddgg2xMQKtgQDntOsG0krxWCV4H+zQmA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>, Weedy <weedy2887@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 02/03/2015 07:49 PM, Roger Heflin wrote:
> In general if you completely disable write caching things will likely
> be unusable.    When I have benchmarked things attempting to turn off
> write cache performance has been mostly unusable.
> 
> I usually change /etc/sysctl.conf and change these entries to control
> the amount of dirty cache.
> 
> vm.dirty_background_bytes = 25000000
> vm.dirty_bytes = 50000000
> 
> That says max dirty allowed is 50mb, and it syncs down to 25mb when it syncs.

Er, where do you have this from? 
dirty_background_bytes and dirty_bytes are more about non-blocking and 
blocking dirty writes. And about the amount of dirty data that triggers 
it (i.e. there is no need to flush temporary file data to disk if files
get immediately deleted after writing them)
 
linux/Documentation/sysctl/vm.txt

==============================================================

dirty_background_bytes

Contains the amount of dirty memory at which the background kernel
flusher threads will start writeback.

Note: dirty_background_bytes is the counterpart of dirty_background_ratio. Only
one of them may be specified at a time. When one sysctl is written it is
immediately taken into account to evaluate the dirty memory limits and the
other appears as 0 when read.

==============================================================


==============================================================

dirty_bytes

Contains the amount of dirty memory at which a process generating disk writes
will itself start writeback.

Note: dirty_bytes is the counterpart of dirty_ratio. Only one of them may be
specified at a time. When one sysctl is written it is immediately taken into
account to evaluate the dirty memory limits and the other appears as 0 when
read.

Note: the minimum value allowed for dirty_bytes is two pages (in bytes); any
value lower than this limit will be ignored and the old configuration will be
retained.

==============================================================



Bernd
