From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID1, hot-swap and boot integrity
Date: Tue, 06 Mar 2007 18:18:11 -0500
Message-ID: <45EDF6B3.8080305@tmr.com>
References: <45E82EF8.9000106@laurelnetworks.com> <12721.45EB026B.1040503@zytor.com> <45ECAC2D.4010404@laurelnetworks.com> <45ECADF0.10906@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45ECADF0.10906@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mike Accetta <maccetta@laurelnetworks.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

H. Peter Anvin wrote:
> Mike Accetta wrote:
>> I wonder if having the MBR typically outside of the array and the 
>> relative
>> newness of partitioned arrays are related?  When I was considering 
>> how to
>> architect the RAID1 layout it seemed like a partitioned array on the
>> entire disk worked most naturally.
>
> It's one way to do it, for sure.  The main problem with that, of 
> course, is that it's not compatible with other operating systems. 

sed s/problem/advantage/       ;-)

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

