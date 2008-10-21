From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: Possible Bug in MD?
Date: Tue, 21 Oct 2008 10:16:01 -0700
Message-ID: <e9c3a7c20810211016u7b1c8b33se67eacf301c73441@mail.gmail.com>
References: <cccedfc60810210554q4ed8822eyc93f972fe2d515db@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60810210554q4ed8822eyc93f972fe2d515db@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Oct 21, 2008 at 5:54 AM, Jon Nelson
<jnelson-linux-raid@jamponi.net> wrote:
> I ran into a weird problem recently.
>
> I tried using --stop on an array that was in the process of rebuilding
> (immediately following creation).
>
> mdadm never returned.
>
> After the array was complete, mdadm still had not returned.
>
> An strace of the mdadm process showed, unfortunately, nothing, indicating to me
> that it was stuck in the kernel somewhere.
>
> I have no other information at this time, except that it was with the Rescue
> option from the openSUSE 11.0 x86-64 DVD iso (and thus the stock kernel, mdadm
> version, etc...)
>

Can you determine if hald was running?  I have seen cases where hald
prevents --stop from completing, but I have not debugged further.
Terminating hald allowed --stop to complete.

--
Dan
