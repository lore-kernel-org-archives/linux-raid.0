From: Stephan van Hienen <raid@a2000.nu>
Subject: RE: raid5 slow
Date: Mon, 29 Nov 2004 19:11:59 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0411291901510.32052@adsl.a2000.nu>
References: <200411291713.iATHDtN05760@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200411291713.iATHDtN05760@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 29 Nov 2004, Guy wrote:

> Very odd, RAID5 reading should be about the same as RAID0.
> And your old array confirms that.
> My guess is RAID5 needs some help.  Neil?  Any ideas?
>
> Is your stripe size the same on both?
> Did you allow your array to re-sync before the tests?
stripesize is the same (128k)
and yes i did a resync

