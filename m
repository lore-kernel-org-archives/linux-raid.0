From: Brad Campbell <brad@wasp.net.au>
Subject: Re: "Rebuild" speed on a forced resync
Date: Wed, 12 Jan 2005 08:31:40 +0400
Message-ID: <41E4A82C.4030108@wasp.net.au>
References: <200501120047.j0C0l1928164@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501120047.j0C0l1928164@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: 'RAID Linux' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Guy wrote:
> On my system, iostat only reports since re-boot.  Not since last run of
> iostat.  I use "sar -d" for current speeds.  In the past, sar has agreed
> with /dev/mdstat.
> 

run iostat 5 and it will report since last reboot on the first itteration, then from then on it only 
reports since the last itteration and will update every 5 seconds. Same as vmstat does.

Regards,
Brad
