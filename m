From: Robert L Mathews <lists@tigertech.com>
Subject: Re: RAID 1 failure on single disk causes disk subsystem to lock up
Date: Wed, 02 Apr 2008 11:42:25 -0700
Message-ID: <47F3D391.50003@tigertech.com>
References: <47F020C6.1060809@tigertech.com> <47F3C5B0.2040206@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47F3C5B0.2040206@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen wrote:

> If you look at the change logs for versions between 2.6.8 and 2.6.24 you 
> will see a lot of improvements in disk error handling.  The kernel you 
> are running is probably incapable of handling the particular failure you 
> are getting, at least for values of "handle" which include "cleanly 
> report failure back to the md layer."

Thanks -- yep, that makes sense. I appreciate the advice. I'll see what 
happens now that we're using 2.6.18 instead of 2.6.8.


> Unless you have some very good 
> reason for upgrading to another old kernel
 > ...
 > Security backports seem to be aimed at intrusion prevention and not
 > data security in this case.

Yep. We have to stick to Debian versions offering security support, 
unfortunately, for security reasons. The machines are Web servers that 
allow strangers (aka customers) shell access, and intrusion prevention 
is paramount  :-(  In a few months, the next version of Debian will 
allow us to upgrade to 2.6.24.

Again, thanks for the comments, everyone; much appreciated.

-- 
Robert L Mathews
