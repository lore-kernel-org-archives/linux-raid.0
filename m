From: rob <rob@fantinibakery.com>
Subject: Re: raid0 and iscsi
Date: Mon, 13 Oct 2003 19:33:51 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F8B365F.9060509@fantinibakery.com>
References: <200310130434.h9D4YU0n020486@bach.cs.colostate.edu> <3F8A9736.1020706@fantinibakery.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3F8A9736.1020706@fantinibakery.com>
To: rob <rob@fantinibakery.com>
Cc: Jayshankar Nair <jshankar@CS.ColoState.EDU>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


the test I did faulty.  I mistakenly sent data to a non-raid disk on the 
software raid computer.
for kicks I'll retest and post the results sometime soon.

>
> the command used: rsync -e ssh -a --stats  /bkup3/  fbc5:/bkup3/
>
> here is the result of sending approx 3-gb of data to each:


