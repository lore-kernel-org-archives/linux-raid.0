From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: mkinitrd and RAID6 on FC5
Date: Mon, 23 Apr 2007 10:48:42 -0700
Message-ID: <462CF17A.3030902@zytor.com>
References: <200704230511.l3N5BW701448@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200704230511.l3N5BW701448@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy Watkins <linux-raid@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy Watkins wrote:
> Is this a REDHAT only problem/bug?  If so, since bugzilla.redhat.com gets
> ignored, where do I complain?

Yes, this is Redhat only, and as far as I know, it was fixed a long time 
ago.  I suspect you need to make sure you upgrade your entire system, 
especially mkinitrd, not just the kernel.

	-hpa
