From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: mkinitrd and RAID6 on FC5
Date: Mon, 23 Apr 2007 18:08:07 -0700
Message-ID: <462D5877.7030407@zytor.com>
References: <200704240059.l3O0xl704469@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200704240059.l3O0xl704469@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy Watkins <linux-raid@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy Watkins wrote:
> 
> I tried to update/upgrade and no updates are available for mkinitrd.  Do you
> know what version has the fix?  The bugzilla was never closed, so it seems
> it has not been fixed.
> 
> My version:
> mkinitrd.i386                            5.0.32-2               installed
> 

I guess Red Hat decided not to fix this in FC5.  It does work in FC6; 
for FC5 I guess you're stuck passing --with=raid456 to mkinitrd :-/

	-hpa

