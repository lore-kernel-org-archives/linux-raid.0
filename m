From: Phil Turmel <philip@turmel.org>
Subject: Re: mdadm: can only add devices to linear arrays
Date: Sat, 18 Feb 2017 17:29:34 -0500
Message-ID: <6c5ca569-0ffa-ebfd-2c42-fc2043ae473f@turmel.org>
References: <dffb96dc-ee78-4bad-82a8-7f9cfdeb80cd@EXHT01.net.ucsf.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <dffb96dc-ee78-4bad-82a8-7f9cfdeb80cd@EXHT01.net.ucsf.edu>
Sender: linux-raid-owner@vger.kernel.org
To: "Boylan, Ross" <Ross.Boylan@ucsf.edu>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/17/2017 09:33 PM, Boylan, Ross wrote:
> I got "mdadm: can only add devices to linear arrays" when I did not
> expect it.  Can anyone explain what's  going on, and what the right
> way to handle the situation is?
> 
> In brief, I had a raid1 set for 2 devices, but with only 1.  I tried
> adding a 2nd.

I think you simply misunderstood the use of --grow.  All you needed was
--add to place a new device in the empty slot.

Use --grow to change the layout or number of devices of a non-degraded
array.  Use --add, --fail, and --remove to manage the devices in an
array without changing its structure.

Often, you see --grow with an --add because a spare is needed for the
structural changes one is commanding, and it is fine to combine the
operations (adding a spare then growing onto it).

Phil
