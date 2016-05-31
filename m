From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID6 recovery with 6/9 drives out-of-sync
Date: Tue, 31 May 2016 15:19:12 -0400
Message-ID: <574DE3B0.8000409@turmel.org>
References: <C50C72C6-FC75-4863-B743-F63F09AF93B0@illinois.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C50C72C6-FC75-4863-B743-F63F09AF93B0@illinois.edu>
Sender: linux-raid-owner@vger.kernel.org
To: "Peckins, Steven E" <speckins@illinois.edu>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/30/2016 10:43 PM, Peckins, Steven E wrote:
> 
> I have a system with a 9+1 disk RAID6 array that has "3 drives and 1 spare - not enough to start the array."  The metadata version is 1.1; mdadm version is v3.3.
> 
> The component devices in the array are supposed to be multipath devices (dm-multipath), but for some reason, when the server was restarted, md grabbed both dm-* components and raw devices.  I *think* that this is what caused the problem.

Quite possible.  You probably need a DEVICES clause in your mdadm.conf
to exclude the raw devices from the arrays.


> I'm seeking advice on how to proceed at this point.  If more information is required, please ask.

Hmmm.  The partial success on mdadm --force suggests trying that again.
 Possible with --force twice on the command line.

Forced assembly is precisely what you need -- don't despair and attempt
anything else.

Do review /proc/mdstat before each assembly attempt to make sure nothing
is partially assembled with those devices or the underlying raw devices.

Phil

