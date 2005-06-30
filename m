From: Eric Pretorious <eric@pretorious.net>
Subject: Re: linux-raid compatable w/ Adaptec AIC-7902?
Date: Thu, 30 Jun 2005 10:14:11 -0700
Message-ID: <200506301014.11454.eric@pretorious.net>
References: <200506300210.j5U2Acp04142@www.watkins-home.com>
Reply-To: eric@pretorious.net
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200506300210.j5U2Acp04142@www.watkins-home.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday 29 June 2005 07:10 pm, Guy wrote:
>> md: delaying resync of md0 until md2 has finished resync (they share one
>> or more physical units)
>> md: delaying resync of md1 until md2 has finished resync (they share one
>> or more physical units)
>> ...
>> 
>> Should I be concerned by the last two lines?
>No, this is normal.  Your 3 arrays are on the same disk(s).  In this case,
>it is faster to do them 1 at a time.

Oh - I get it: md can only work on one RAID at a time because md0, md1, & md2 
are all on sda & sdb (i.e., sda is mirrored on sdb). Thanks!

-- 
Eric P.,
Truckee, CA
