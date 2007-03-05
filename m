From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID1, hot-swap and boot integrity
Date: Mon, 05 Mar 2007 15:55:28 -0800
Message-ID: <45ECADF0.10906@zytor.com>
References: <45E82EF8.9000106@laurelnetworks.com> <12721.45EB026B.1040503@zytor.com> <45ECAC2D.4010404@laurelnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45ECAC2D.4010404@laurelnetworks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Accetta <maccetta@laurelnetworks.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mike Accetta wrote:
> I wonder if having the MBR typically outside of the array and the relative
> newness of partitioned arrays are related?  When I was considering how to
> architect the RAID1 layout it seemed like a partitioned array on the
> entire disk worked most naturally.

It's one way to do it, for sure.  The main problem with that, of course, 
is that it's not compatible with other operating systems.

	-hpa
