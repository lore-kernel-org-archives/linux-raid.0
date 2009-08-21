From: Info@quantum-sci.net
Subject: Re: Help
Date: Fri, 21 Aug 2009 13:51:10 -0700
Message-ID: <200908211351.11056.Info@quantum-sci.net>
References: <200908210627.06241.Info@quantum-sci.net> <200908211220.28701.Info@quantum-sci.net> <4A8EF798.9010600@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A8EF798.9010600@anonymous.org.uk>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday 21 August 2009 12:38:00 John Robinson wrote:
> Well, it won't let you remove the only thing keeping the array active. 
> Stop the array first with `mdadm --stop /dev/md0`. After that I think 
> you can just create your new RAID-1 array without doing anything else.

WHEW, thank you.


