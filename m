From: Jean-Baptiste Thomas <cau2jeaf1honoq@laposte.net>
Subject: Re: <DKIM> Re: Paranoid mode for RAID-1 ?
Date: Mon, 27 Apr 2015 12:18:09 +0200 (CEST)
Message-ID: <743316986.23005258.1430129889889.JavaMail.zimbra@laposte.net>
References: <972437107.22507366.1430116679975.JavaMail.zimbra@laposte.net> <4ADD42F9-407A-4266-A1FC-B92F3D46C36F@insync.za.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4ADD42F9-407A-4266-A1FC-B92F3D46C36F@insync.za.net>
Sender: linux-raid-owner@vger.kernel.org
To: Pieter De Wit <pieter@insync.za.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2015-04-27 20:45 +1200, Pieter De Wit wrote:

> Sorry for jumping in late - but let's say it does "work" and a
> drive returns an error, is that data lost ? Or which drive is
> "right"?

(Assuming that by "returns an error", you mean succeeds but the
data does not no match what the other(s) returned.)

Let's say there is a setting for how many components must agree.
If they're not unanimous, read all the other components and look
for a majority. The components in the minority are flagged
faulty and the array is degraded but the read succeeds.

If there is no majority, retry a few times. If a majority is
found, all components which ever were in the minority are
flagged faulty and the array is degraded but the read succeeds.

If no majority is found, degrade all components, fail the read
and stop the array. Or whatever is needed to prevent all further 
writes to this array and let the user investigate.
