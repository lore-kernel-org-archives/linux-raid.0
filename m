From: David Greaves <david@dgreaves.com>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10
 crashing repeatedly and hard)
Date: Wed, 05 Jan 2005 17:26:35 +0000
Message-ID: <41DC234B.4090806@dgreaves.com>
References: <200501051707.j05H7m926213@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501051707.j05H7m926213@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy wrote:

>RAID does not cause bad data!
>  
>
Guy - how can you speak such heresy!!      ;)
Haven't you seen the special 'make_undetectable_error(float p)' function?

>Bad data can get on any disk, even if it is part of a RAID system.
>The bad data does not come from the hard disk, CRCs prevent that.
>
>The problem is:  Where does the bad data come from?
>Bad memory?  No, everyone use ECC memory, right?
>  
>
I like to blame cosmic rays - I just like the image ;)

Of course voltage fluctuations, e/m interference, thermal variations, 
mechanical interfaces, dust capacitance/resistance, insects shorts... 
anywhere inside the tin box between the media and the corners of the 
motherboard. It's amazing that some machines even boot.

David

