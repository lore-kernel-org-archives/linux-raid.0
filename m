From: Phil Turmel <philip@turmel.org>
Subject: Re: Problems creating MS-RAID1: "device .. not suitable for any style
 of raid array" / "Device or resource busy"
Date: Fri, 06 May 2011 10:52:54 -0400
Message-ID: <4DC40B46.2020906@turmel.org>
References: <4DC4029F020000A100005CA7@gwsmtp1.uni-regensburg.de> <4DC40866.30601@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DC40866.30601@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hmm.  Glossed right over a key bit:

On 05/06/2011 08:15 AM, Ulrich Windl wrote:
> I was able to create one RAID1 array, but not a second one. I have no idea what's wrong, but my guesses are:
> 

But the commands and responses for /dev/md0 below that suggest that the one array you seem to have created isn't actually working, even though is says "Started".

Can you also show the contents of /proc/mdstat (if it exists...  if my first suggestion is correct, it won't be there).

Phil
