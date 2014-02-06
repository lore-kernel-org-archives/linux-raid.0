From: Joe Landman <joe.landman@gmail.com>
Subject: Re: Storage system
Date: Thu, 06 Feb 2014 14:24:35 -0500
Message-ID: <52F3E173.8020305@gmail.com>
References: <20140206180909.GA2419@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140206180909.GA2419@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/06/2014 01:09 PM, Piergiorgio Sartor wrote:
> Hi all,
>
> this question is only partially related to Linux MD,
> but since the experts are here, I think it would not
> be a big problem to ask here.
>
> I'm considering a storage system.
> This is based on HDD "rust".
> It should have RAID-6, for protection agaist disk
> failure(s).
> It should have LUKS (or similar), in order to simplify
> HDD disposal (disk that are still somehow readable will
> not need to be wiped out before dumping them).

Can you use the full disk encryption mechanisms?  This could 
(potentially) save a layer, though the down side is that you don't have 
control over it.  We've not used it, most of our customers destroying 
disks tend to physically destroy them, and not trust the encryption layer.

> It should have LVM, as flexible partition system.
>
> Now, given that the HDD are always the lower layer, the
> others can be combined in any order.
> Six possible combinations, specifically, naming:
>
> H: HDD
> R: RAID
> E: encryption
> L: LVM
>
> We can have:
>
> HREL
> HRLE
> HLRE
> HLER
> HERL
> HELR

If this is a heavily used system, you'll likely want to start with HR 
for performance reasons.  If you can eliminate the E with FDE as noted, 
and if it works well, great.  If not, I'd suggest putting that next. 
LVM isn't a fast system, so its better not to put it on a fast system. 
LUKS can be fast with good CPUs and reasonable controllers/disks.


