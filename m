From: Nix <nix@go-nix.ca>
Subject: Re: pdc20276 /dev/ataraid/disc2 problem
Date: 19 Aug 2003 12:41:18 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1061318478.8360.13.camel@tux.go-nix.ca>
References: <20030819104106.A29954@itqb.unl.pt>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20030819104106.A29954@itqb.unl.pt>
To: Antonio Maretzek <antonio.maretzek@microcortex.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2003-08-19 at 03:41, Antonio Maretzek wrote:
> I use the 20276 only as an IDE controler (and with 2 disks only..).
> 
> If I got you right, this is what you want...

Thanks for all the info, but no.  I would very much like the 20276 to be
a RAID controller, rather than an IDE controller, however, I would like
to gain access to all my drives.  Currently, as I pointed out in my
initial email, the RAID controller creates a RAID0 out of the two master
drives connected to it, and what looks like 2 more RAID0s out of the 2
slave drives.  Now why it would create a RAID0 out of a single drive
eludes me.  However, it does not allow me to create a single RAID0 out
of the 2 slave drives together, because the damned thing is a "Lite"
version of the BIOS which only accomodates one RAID0 array.

IOW, this is my current setup (or so it sounds from what the BIOS is
telling me:

+----------------+
|primary master  |
|                +-/dev/ataraid/disc0 (RAID0)
|secondary master|
+----------------+

+-------------+
|primary slave+-/dev/ataraid/disc1 (RAID0)
+-------------+

+---------------+
|secondary slave+-/dev/ataraid/disc2 (RAID0) ????
+---------------+

This is what my BIOS says on bootup (I mentioned this in my previous
message):

===================================================
ID    Mode        Size    Track-Mapping  Status
1     2+0 Stripe  40839M  4965/255/63    Functional
2     1+0 Stripe  39999M  4862/255/63    Functional
3 *   1+0 Stripe  39999M  4862/255/63    Functional

Does this output reflect the picture I drew above ?  In my mind it seems
to, except for the '*' next to the 3.  I don't understand the meaning of
the '*', but that drive seems to be my missing /dev/ataraid/disc2, so I
doubt the presence of the star and the fact that it's missing are not
related.

If somebody has had some experience with this problem, please let me
know !



Thanks !

P.S.:  I'm not subscribed to linux-raid, so please CC me on the answer. 
Thanks again !

